# frozen_string_literal: true

require "gtk4"
require "adwaita"
require_relative "shell_model"
require_relative "panel_list"
require_relative "panel_loader"
require_relative "log"

module GnomeControlCenter
  # Window is the shell's single top-level window: a sidebar listing every
  # panel (PanelList) and a content area that is one Adwaita::NavigationView
  # the active panel, and any subpages it pushes, live in.
  #
  # Ported from upstream's shell/cc-window.c/.h, an AdwApplicationWindow
  # built from a GtkBuilder template with an AdwNavigationSplitView, a
  # search bar, window-state persistence through GSettings and a responsive
  # breakpoint that drops the sidebar at narrow widths. This port keeps the
  # split view, the search bar and the panel-switching/back-navigation
  # behaviour; it drops GSettings-backed window geometry persistence (no
  # compiled schema exists yet in this port) and the explicit AdwBreakpoint
  # (AdwNavigationSplitView already collapses its own sidebar at narrow
  # widths without one).
  class Window < Adwaita::ApplicationWindow
    def initialize(application, model)
      super(application)
      @model = model
      @current_panel = nil
      @previous_panel_ids = []
      self.title = "Settings"
      set_default_size(1100, 700)
      self.content = toast_overlay
    end

    def build
      tap do
        toast_overlay.tap { |overlay| overlay.child = split_view }

        split_view.tap do |view|
          view.sidebar = sidebar_page
          view.content = content_page
        end

        sidebar_toolbar.tap do |toolbar|
          toolbar.add_top_bar(sidebar_header)
          toolbar.add_top_bar(search_bar)
          toolbar.content = panel_list.build
        end

        content_toolbar.tap do |toolbar|
          toolbar.content = navigation_view
        end

        search_entry.tap do |entry|
          entry.signal_connect("search-changed") { panel_list.search_query = entry.text }
          entry.signal_connect("activate") { panel_list.search_query = entry.text }
        end

        search_bar.tap do |bar|
          bar.connect_entry(search_entry)
          bar.key_capture_widget = self
        end

        search_button.tap do |button|
          button.signal_connect("toggled") { search_bar.search_mode_enabled = button.active? }
        end
      end
      PanelLoader.populate(@model)
      panel_list.refresh
      activate_first_panel
      self
    end

    # Upstream's cc_window_get_navigation_view.
    def navigation_view = @navigation_view ||= Adwaita::NavigationView.new

    # Upstream's cc_window_get_active_panel.
    attr_reader :current_panel

    # Upstream's cc_window_set_active_panel_from_id, taking `parameters` as
    # a plain Ruby array already unwrapped from the shell's GVariant `av`
    # deep-link argument — see #activate_panel_variant, which does that
    # unwrapping for the real "app.launch-panel" activation path wired in
    # Application.
    def activate_panel(id, parameters: [])
      Log.log("cc-window", :debug, "Activating panel '#{id}' with #{parameters.length} parameter(s)")
      panel = PanelLoader.load(id, self, parameters: parameters)

      if panel.nil?
        warn("No such panel: '#{id}'")
      else
        @current_panel&.deactivate
        if @current_panel_id && @current_panel_id != id
          @previous_panel_ids << @current_panel_id
        end
        @current_panel_id = id
        @current_panel = panel
        panel_list.active_panel_id = id
        navigation_view.replace(@current_panel.navigation_stack_pages)
        split_view.show_content = true
      end
    end

    attr_reader :current_panel_id

    # Upstream's "launch-panel" app action handler unwraps the activation
    # GVariant `(sav)` — panel id plus an `av` parameter array — before
    # calling cc_window_set_active_panel_from_id. The ruby-gnome GObject
    # Introspection binding already converts that whole `(sav)` tuple into
    # a plain Ruby `[id, params]` pair by the time a GAction's "activate"
    # handler sees it (each `v` element unwrapped to its concrete Ruby
    # value in turn), so there is no GVariant left to unwrap by hand here —
    # this just gives that pair the same real panel-switch and subpage
    # behaviour #activate_panel already provides.
    def activate_panel_variant(id, params)
      activate_panel(id, parameters: Array(params))
    end

    private

      def activate_first_panel
        first = PanelLoader.registrations.first
        if first
          activate_panel(first.id)
        end
      end

      def on_show_panel(id) = activate_panel(id)

      def toast_overlay = @toast_overlay ||= Adwaita::ToastOverlay.new

      def split_view
        @split_view ||= Adwaita::NavigationSplitView.new.tap do |view|
          view.min_sidebar_width = 240
          view.max_sidebar_width = 320
          view.sidebar_width_fraction = 0.3
        end
      end

      def sidebar_page = @sidebar_page ||= Adwaita::NavigationPage.new(sidebar_toolbar, "Settings")
      def content_page = @content_page ||= Adwaita::NavigationPage.new(content_toolbar, "Panel")
      def sidebar_toolbar = @sidebar_toolbar ||= Adwaita::ToolbarView.new
      def content_toolbar = @content_toolbar ||= Adwaita::ToolbarView.new

      def sidebar_header
        @sidebar_header ||= Adwaita::HeaderBar.new.tap do |bar|
          bar.title_widget = Adwaita::WindowTitle.new("Settings", "")
          bar.pack_end(menu_button)
          bar.pack_end(search_button)
        end
      end

      # Upstream's cc-window.blp primary_menu MenuButton (icon
      # open-menu-symbolic): Keyboard Shortcuts, Help and About Settings.
      def menu_button
        @menu_button ||= Gtk::MenuButton.new.tap do |button|
          button.icon_name = "open-menu-symbolic"
          button.tooltip_text = "Main Menu"
          button.menu_model = primary_menu
        end
      end

      # Upstream's `menu primary_menu` block in cc-window.blp.
      def primary_menu
        @primary_menu ||= Gio::Menu.new.tap do |menu|
          menu.append("Keyboard Shortcuts", "app.shortcuts")
          menu.append("Help", "app.help")
          menu.append("About Settings", "app.about")
        end
      end

      def search_button
        @search_button ||= Gtk::ToggleButton.new.tap do |button|
          button.icon_name = "system-search-symbolic"
          button.tooltip_text = "Search"
        end
      end

      def search_bar = @search_bar ||= Gtk::SearchBar.new.tap { |bar| bar.child = search_entry }
      def search_entry = @search_entry ||= Gtk::SearchEntry.new.tap { |entry| entry.placeholder_text = "Search Settings" }

      def panel_list
        @panel_list ||= PanelList.new(@model, on_show_panel: method(:on_show_panel))
      end
  end
end
