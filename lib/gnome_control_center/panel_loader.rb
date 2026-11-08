# frozen_string_literal: true

module GnomeControlCenter
  # PanelLoader is the shell's registry of available panels: the metadata
  # that populates ShellModel (and from there the sidebar and search), and
  # the panel class each id instantiates when activated.
  #
  # Ported from upstream's shell/cc-panel-loader.c/.h, which lists every
  # panel's GType getter against the panel's own .desktop file (read for its
  # name, description, icon and keywords) behind Meson build-time #ifdefs
  # for the handful of panels that are optionally compiled. This port has
  # one build, so there are no #ifdefs, and reads the panel's display
  # metadata straight off the Ruby class rather than round-tripping it
  # through a desktop file. Panels this round has not ported yet are simply
  # absent, not registered with a stub — see CLAUDE.md / the task notes for
  # what's left.
  module PanelLoader
    Registration = Struct.new(
      :id,
      :category,
      :name,
      :description,
      :icon,
      :keywords,
      :panel_class,
      keyword_init: true,
    )

    def self.registrations = @registrations ||= []

    # Upstream's PANEL_TYPES table entries each name their category via the
    # .desktop file's OnlyShowIn/Categories; here a panel registers itself
    # directly.
    def self.register(id, category:, name:, description:, icon:, panel_class:, keywords: [])
      registrations << Registration.new(
        id:          id,
        category:    category,
        name:        name,
        description: description,
        icon:        icon,
        keywords:    keywords,
        panel_class: panel_class,
      )
    end

    def self.registration_for(id) = registrations.find { |reg| reg.id == id }

    # Upstream's cc_panel_loader_load_panel: build the panel instance for
    # `id`, handing it the window as upstream's "window" construct property
    # does, and `parameters` as upstream's "parameters" construct property
    # does (the shell's deep-link `av` arguments, already unwrapped to a
    # plain Ruby array).
    def self.load(id, window, parameters: [])
      registration_for(id)&.then { |reg| reg.panel_class.new(window, parameters: parameters) }
    end

    # Feeds every registration into a ShellModel, upstream's
    # cc_shell_model_add_item loop in cc_window_constructed.
    def self.populate(model)
      registrations.each do |reg|
        model.add_item(reg.category, id: reg.id, name: reg.name, description: reg.description, icon: reg.icon, keywords: reg.keywords)
      end
    end
  end
end
