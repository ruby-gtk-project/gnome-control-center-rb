# frozen_string_literal: true

require "gtk4"
require "adwaita"
require_relative "shell_model"
require_relative "panel_loader"
require_relative "window"
require_relative "panels/about_panel"

module GnomeControlCenter
  # The port's application entry point.
  #
  # Ported from upstream's shell/cc-application.c and shell/main.c: create
  # the GApplication, register the panels the shell knows about, and on
  # "activate" build (or re-present) the one shell window.
  #
  # House style (see .claude/skills/ruby-gtk): every widget is a memoized
  # method, all configuration lives in its `tap`, assembly happens only in
  # `build`, and the launcher is one expression.
  class Application
    def build
      register_panels
      app.tap do
        app.signal_connect("activate") do
          window.present
        end
      end
    end

    # Adwaita::Application is broken in the Ruby bindings; the application
    # object comes from Gtk, and Adwaita::ApplicationWindow (composed with
    # it, as here, rather than subclassed from it) still works.
    def app = @app ||= Gtk::Application.new("org.rubygtkproject.GnomeControlCenter", :default_flags)

    def model = @model ||= ShellModel.new

    def window = @window ||= Window.new(app, model).build

    private

      # Upstream's cc_panel_loader.c PANEL_TYPES table. This round ports one
      # panel; see the task notes for the rest.
      def register_panels
        PanelLoader.register(
          "about",
          category:    :details,
          name:        "About",
          description: "Hardware and software system information",
          icon:        "dialog-information-symbolic",
          keywords:    %w[About System Information Hardware Firmware Memory Processor OS Kernel],
          panel_class: Panels::AboutPanel,
        )
      end
  end
end
