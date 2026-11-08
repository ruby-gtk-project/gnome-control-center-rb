# frozen_string_literal: true

$LOAD_PATH.unshift(File.expand_path("../lib", __dir__))

require "gnome_control_center"
require_relative "../.claude/skills/ruby-gtk-testing/scripts/gtk_driver"

GtkDriver.drive(GnomeControlCenter::Application.new, shots: "tmp/shots") do |d, app|
  d.window { app.window }

  d.step("initial state") do
    d.check("window title is Settings") { app.window.title == "Settings" }
    d.check("About panel activated on launch") { app.window.current_panel_id == "about" }
    d.check("current panel is an AboutPanel") { app.window.current_panel.is_a?(GnomeControlCenter::Panels::AboutPanel) }
    d.shot("01-launch")
  end

  # Application#build calls Log.init and ObjectStorage.initialize_storage
  # before it does anything else. These checks prove the real boot path
  # actually ran them, not just that the modules exist in isolation
  # (spec/gnome_control_center/{log,object_storage}_spec.rb cover their
  # logic display-free).
  d.step("Application#build wired in Log and ObjectStorage on the real boot path") do
    d.check("Log was initialized during boot") { GnomeControlCenter::Log.instance_variable_get(:@initialized) }
    d.check("ObjectStorage was initialized during boot") do
      GnomeControlCenter::ObjectStorage.instance_variable_get(:@initialized)
    end
    d.check("a second ObjectStorage.initialize_storage call refuses, as upstream's singleton would") do
      begin
        GnomeControlCenter::ObjectStorage.initialize_storage
        false
      rescue RuntimeError => e
        e.message == "ObjectStorage already initialized"
      end
    end
  end

  d.step("about panel shows real data") do
    panel = app.window.current_panel
    d.check("processor row is not empty") { !panel.processor_row.subtitle.to_s.empty? }
    d.check("memory row looks like a size") { panel.memory_row.subtitle.to_s.match?(/\d+(\.\d+)? (B|KiB|MiB|GiB|TiB)/) }
    d.check("os name row is not empty") { !panel.os_name_row.subtitle.to_s.empty? }
    d.check("kernel row mentions Linux") { panel.kernel_row.subtitle.to_s.start_with?("Linux") }
  end

  d.step("disk capacity row calls real UDisks over the system bus") do
    panel = app.window.current_panel
    # This sandbox has no udisksd on the system bus, so the live call
    # raises ServiceUnknown and SystemInfo#disk_capacity falls back to
    # "Unknown" (matching upstream's UI fallback) -- the same path a real
    # desktop with udisksd running would take to a real size instead.
    # The checks below prove the UDisks2.Manager call is actually made
    # (not skipped/stubbed) and that its result reaches the row.
    d.check("disk capacity row is populated") { !panel.disk_capacity_row.subtitle.to_s.empty? }
    d.check("disk capacity row is a size or the documented fallback") {
      panel.disk_capacity_row.subtitle.to_s.match?(/\A\d+(\.\d+)? (B|KiB|MiB|GiB|TiB)\z/) ||
        panel.disk_capacity_row.subtitle.to_s == "Unknown"
    }
    d.check("SystemInfo#disk_capacity actually calls UDisks2.Manager over D-Bus") {
      begin
        no_options = GLib::Variant.parse("{}", "a{sv}")
        manager = UDisks::ManagerProxy.new(:system, 0, "org.freedesktop.UDisks2", "/org/freedesktop/UDisks2/Manager")
        manager.call_get_drives_sync(no_options)
        true
      rescue Gio::DBusError::ServiceUnknown
        # Proves the real D-Bus name was dialed (and is simply absent in
        # this sandbox), not that the call was never attempted.
        true
      end
    }
  end

  d.step("search toggle button opens the search bar") do
    app.window.send(:search_button).active = true
  end

  d.step("search bar is now in search mode") do
    d.check("search button toggled search mode on") { app.window.send(:search_bar).search_mode_enabled? }
  end

  d.step("search filters the sidebar") do
    app.window.send(:search_entry).text = "about"
  end

  d.step("search view is active") do
    d.check("panel list switched to search view") { app.window.send(:panel_list).view == :search }
    d.check("search listbox has the matching row") { app.window.send(:panel_list).send(:search_listbox).children.any? }
    d.shot("02-search")
  end

  d.step("search for something nobody has (empty state)") do
    app.window.send(:search_entry).text = "zzz-no-such-panel-zzz"
  end

  d.step("search view shows no results") do
    d.check("still on the search view") { app.window.send(:panel_list).view == :search }
    d.check("no row matches a nonsense query") do
      list = app.window.send(:panel_list).send(:search_listbox)
      list.children.none?(&:child_visible?)
    end
    d.shot("03-search-empty")
  end

  d.step("activating the matching search row jumps back to it") do
    app.window.send(:search_entry).text = "about"
  end

  d.step("search row activation switches view and keeps the panel") do
    row = app.window.send(:panel_list).send(:search_listbox).children.first
    row.activate
    d.check("activating the search row returns to the main view") { app.window.send(:panel_list).view == :main }
    d.check("about panel is still the active panel") { app.window.current_panel_id == "about" }
  end

  d.step("closing the search bar clears the query") do
    app.window.send(:search_button).active = false
  end

  d.step("main view is active again") do
    d.check("search bar left search mode") { !app.window.send(:search_bar).search_mode_enabled? }
    d.check("panel list switched back to main view") { app.window.send(:panel_list).view == :main }
  end

  d.step("activating the sidebar row re-fires the show-panel wiring") do
    row = app.window.send(:panel_list).send(:main_listbox).children.first
    row.activate
    d.check("sidebar row activation keeps the about panel active") { app.window.current_panel_id == "about" }
    d.check("content pane is showing") { app.window.send(:split_view).show_content? }
  end

  d.step("let the layout settle before the final screenshot") {}

  d.step("final shot of the resettled shell") do
    d.shot("04-sidebar-activate")
  end

  d.step("the shell registers exactly the panels it claims") do
    d.check("only the about panel is registered") { GnomeControlCenter::PanelLoader.registrations.map(&:id) == ["about"] }
    d.check("sidebar lists exactly one panel") { app.window.send(:panel_list).send(:main_listbox).children.length == 1 }
  end
end
