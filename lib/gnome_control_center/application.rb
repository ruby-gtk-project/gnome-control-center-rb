# frozen_string_literal: true

require "gtk4"
require "adwaita"
require_relative "log"
require_relative "object_storage"
require_relative "shell_model"
require_relative "panel_loader"
require_relative "window"
require_relative "shortcuts_dialog"
require_relative "panels/about_panel"
require_relative "../gnome/control/center/rb/version"

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
      Log.init
      ObjectStorage.initialize_storage
      register_panels
      app.tap do
        register_actions
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

      # Upstream's cc_app_actions GActionEntry table in cc-application.c:
      # "shortcuts" (not yet a registered action upstream at HEAD, but
      # bound by both cc-window.blp's primary menu and
      # shell/shortcuts-dialog.blp's own "Keyboard shortcuts" row to
      # "app.shortcuts" — this port gives it the implementation those two
      # already assume exists), "help", "about" and "launch-panel".
      # "launch-single-panel-mode" and "quit" are out of scope this round:
      # neither the search provider nor a --panel CLI launch exists yet to
      # call them.
      def register_actions
        app.add_action(shortcuts_action)
        app.add_action(help_action)
        app.add_action(about_action)
        app.add_action(launch_panel_action)
      end

      def shortcuts_action
        @shortcuts_action ||= Gio::SimpleAction.new("shortcuts").tap do |action|
          action.signal_connect("activate") { ShortcutsDialog.new.build.present(window) }
        end
      end

      # Upstream's help_activated: the active panel's own help URI, else
      # the shell's default, launched through the desktop help handler.
      def help_action
        @help_action ||= Gio::SimpleAction.new("help").tap do |action|
          action.signal_connect("activate") do
            uri = window.current_panel&.help_uri || "help:gnome-help/prefs"
            Gtk::UriLauncher.new(uri).launch(window) { |_launcher, _result| }
          end
        end
      end

      # Upstream's about_activated, minus adw_about_dialog_new_from_appdata
      # (no compiled metainfo resource exists in this port): the same
      # fields set directly on an Adwaita::AboutDialog.
      def about_action
        @about_action ||= Gio::SimpleAction.new("about").tap do |action|
          action.signal_connect("activate") { about_dialog.present(window) }
        end
      end

      def about_dialog
        Adwaita::AboutDialog.new.tap do |dialog|
          dialog.application_name = "Settings"
          dialog.version = Gnome::Control::Center::Rb::VERSION
          dialog.developer_name = "The GNOME Project"
          dialog.copyright = "© 1998 The GNOME Project"
          dialog.license_type = :gpl_2_0
        end
      end

      # Upstream's "launch-panel" action, parameter type "(sav)": a panel
      # id plus the shell's `av` deep-link parameter array. The GObject
      # Introspection binding hands the whole tuple to the handler already
      # unwrapped into a plain `[id, params]` Ruby pair (see
      # Window#activate_panel_variant's comment), so this just forwards it.
      def launch_panel_action
        @launch_panel_action ||= Gio::SimpleAction.new("launch-panel", GLib::VariantType.new("(sav)")).tap do |action|
          action.signal_connect("activate") do |_action, parameter|
            id, params = parameter
            window.activate_panel_variant(id, params)
          end
        end
      end
  end
end
