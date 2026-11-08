# frozen_string_literal: true

require "adwaita"

module GnomeControlCenter
  # Base class panels subclass for shell-managed navigation: a stack of
  # Adwaita::NavigationPages pushed onto the window's single
  # Adwaita::NavigationView, subpages reachable by tag — either "static"
  # ones instantiated lazily from a class, or ones a panel hands over as a
  # built instance — and a per-panel Gio::Cancellable the window cancels
  # when the panel is deactivated.
  #
  # Ported from upstream's shell/cc-panel.c / cc-panel.h. Upstream is an
  # abstract AdwNavigationPage with a GtkBuildable "subpage" child type (for
  # subpages declared in the panel's own .blp/.ui) and a "parameters"
  # GVariant construct property the shell's D-Bus activation path feeds
  # deep-link arguments into (an `av` — array of variants — whose first
  # element, when it is a string, names the target subpage). This port has
  # no GtkBuilder templates, so subpages are registered in Ruby
  # (`add_subpage`, `add_static_subpage`) rather than declared as buildable
  # children; `parameters` becomes a plain constructor keyword carrying that
  # same array, already unwrapped from the GVariant into plain Ruby values
  # by Window#activate_panel (see its comment for the unwrapping).
  class Panel < Adwaita::NavigationPage
    def initialize(window, child, title, parameters: [])
      super(child, title)
      @window = window
      @parameters = parameters
      @subpages = {}
      @static_subpages = {}
      @navigation_stack = [self]
      @single_page_mode = false
      if parameters.first.is_a?(String)
        push_initial_subpage(parameters.first)
      end
    end

    attr_reader :window, :navigation_stack

    # Upstream's PROP_PARAMETERS getter: the full deep-link argument array
    # the shell activated this panel with (empty when activated plainly).
    # A subclass whose upstream counterpart reads arguments past the
    # subpage tag (e.g. a setting to highlight) reads them from here.
    attr_reader :parameters

    # Upstream's cc_panel_get_cancellable: lazily created, one per panel.
    def cancellable = @cancellable ||= Gio::Cancellable.new

    # Upstream's cc_panel_deactivate.
    def deactivate
      cancellable.cancel
    end

    # Upstream's cc_panel_add_subpage: a built AdwNavigationPage instance,
    # kept under `page_tag` for later lookup by `cc_panel_push_subpage` /
    # window navigation.
    def add_subpage(tag, subpage)
      @subpages[tag] = subpage
    end

    # Upstream's cc_panel_add_static_subpage: a page class instantiated only
    # when its tag is actually requested.
    def add_static_subpage(tag, page_class)
      @static_subpages[tag] = page_class
    end

    # Upstream's cc_panel_push_subpage.
    def push_subpage(subpage)
      window.navigation_view.push(subpage)
    end

    # Upstream's cc_panel_enable_single_page_mode: the panel has no "back"
    # affordance of its own, because it is the window's only content.
    def enable_single_page_mode
      @single_page_mode = true
      window.navigation_view.visible_page&.tap { |page| page.can_pop = false }
    end

    # Upstream's cc_panel_get_subpages.
    def subpages = @subpages.values

    # Upstream's cc_panel_get_static_subpage.
    def static_subpage(tag)
      page_class = @static_subpages[tag]
      page_class&.then { |klass| klass.ancestors.include?(Panel) ? klass.new(window) : klass.new }
    end

    # Upstream's cc_panel_get_navigation_stack.
    def navigation_stack_pages = @navigation_stack

    # Upstream's cc_panel_get_help_uri, a virtual with no default
    # implementation; subclasses that have a help page override this.
    def help_uri = nil

    private

      # Upstream's PROP_PARAMETERS handling in cc_panel_set_property, which
      # unwraps the shell's `(av)` activation parameters and calls
      # set_subpage() with the first argument when it is a plain string.
      def push_initial_subpage(tag)
        navigation = window.navigation_view
        page = navigation.find_page(tag) || @subpages[tag] || static_subpage(tag)

        if page.nil?
          warn("Invalid subpage: '#{tag}'")
        else
          page.can_pop = !@single_page_mode
          @navigation_stack << page
        end
      end
  end
end
