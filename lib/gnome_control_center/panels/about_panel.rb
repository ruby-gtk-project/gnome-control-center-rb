# frozen_string_literal: true

require "adwaita"
require_relative "../panel"
require_relative "../system_info"

module GnomeControlCenter
  module Panels
    # AboutPanel shows the device's hardware and software identity: vendor,
    # model, firmware, memory, processor, OS name/build/type and kernel
    # version.
    #
    # Ported from upstream's panels/system/about/cc-about-page.c, trimmed to
    # the overview rows SystemInfo can answer for this round (see that
    # class's comment for what's substituted and what's left out — disk
    # capacity, GPU rows, the "copy details" action and the distributor
    # logo). Rows are always shown, with "Unknown" standing in for data this
    # round could not get, rather than toggling row visibility as upstream
    # does — this port never hides a field because its value is empty.
    class AboutPanel < Panel
      def initialize(window, subpage_tag: nil)
        @info = SystemInfo.new
        super(
          window,
toolbar_view,
"About",
subpage_tag: subpage_tag
)
      end

      def toolbar_view
        @toolbar_view ||= Adwaita::ToolbarView.new.tap do |view|
          view.add_top_bar(Adwaita::HeaderBar.new)
          view.content = scrolled_window
        end
      end

      def scrolled_window
        @scrolled_window ||= Gtk::ScrolledWindow.new.tap { |sw| sw.child = clamp }
      end

      def clamp
        @clamp ||= Adwaita::Clamp.new.tap do |c|
          c.maximum_size = 600
          c.margin_top = 24
          c.margin_bottom = 24
          c.margin_start = 12
          c.margin_end = 12
          c.child = content_box
        end
      end

      def content_box
        @content_box ||= Gtk::Box.new(:vertical, 24).tap do |box|
          box.append(hardware_group)
          box.append(software_group)
        end
      end

      def hardware_group
        @hardware_group ||= Adwaita::PreferencesGroup.new.tap do |group|
          group.title = "Hardware"
          group.add(hardware_model_row)
          group.add(firmware_version_row)
          group.add(memory_row)
          group.add(processor_row)
        end
      end

      def software_group
        @software_group ||= Adwaita::PreferencesGroup.new.tap do |group|
          group.title = "Software"
          group.add(os_name_row)
          group.add(os_build_row)
          group.add(os_type_row)
          group.add(kernel_row)
        end
      end

      def hardware_model_row = @hardware_model_row ||= info_row("Hardware Model", @info.hardware_model)
      def firmware_version_row = @firmware_version_row ||= info_row("Firmware Version", @info.firmware_version)
      def memory_row = @memory_row ||= info_row("Memory", @info.memory)
      def processor_row = @processor_row ||= info_row("Processor", @info.processor)
      def os_name_row = @os_name_row ||= info_row("OS Name", @info.os_name)
      def os_build_row = @os_build_row ||= info_row("OS Build", @info.os_build)
      def os_type_row = @os_type_row ||= info_row("OS Type", @info.os_type)
      def kernel_row = @kernel_row ||= info_row("Kernel Version", @info.kernel_version)

      private

        def info_row(title, subtitle)
          Adwaita::ActionRow.new.tap do |row|
            row.title = title
            row.subtitle = subtitle
          end
        end
    end
  end
end
