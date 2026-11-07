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

  d.step("about panel shows real data") do
    panel = app.window.current_panel
    d.check("processor row is not empty") { !panel.processor_row.subtitle.to_s.empty? }
    d.check("memory row looks like a size") { panel.memory_row.subtitle.to_s.match?(/\d+(\.\d+)? (B|KiB|MiB|GiB|TiB)/) }
    d.check("os name row is not empty") { !panel.os_name_row.subtitle.to_s.empty? }
    d.check("kernel row mentions Linux") { panel.kernel_row.subtitle.to_s.start_with?("Linux") }
  end

  d.step("search filters the sidebar") do
    app.window.send(:search_entry).text = "about"
  end

  d.step("search view is active") do
    d.check("panel list switched to search view") { app.window.send(:panel_list).view == :search }
    d.shot("02-search")
  end

  d.step("clearing search returns to main view") do
    app.window.send(:search_entry).text = ""
  end

  d.step("main view is active again") do
    d.check("panel list switched back to main view") { app.window.send(:panel_list).view == :main }
  end
end
