# frozen_string_literal: true

require "adwaita"

module GnomeControlCenter
  # ShortcutsDialog lists the shell's own keyboard shortcuts: general
  # window shortcuts, panel navigation, and search.
  #
  # Ported from upstream's shell/shortcuts-dialog.blp, an Adw.ShortcutsDialog
  # with three Adw.ShortcutsSection children. Two of upstream's four
  # "General" items name an action ("app.help" / "app.shortcuts") rather
  # than an accelerator; this port keeps both as fixed accelerator rows
  # instead (Quit stays a plain accelerator, Search stays a plain
  # accelerator), since the action-name rows exist in the .blp purely so
  # libadwaita can print whatever accelerator is bound to that action, and
  # this port binds those two the same way upstream's accel map does.
  class ShortcutsDialog
    def build
      Adwaita::ShortcutsDialog.new.tap do |dialog|
        dialog.add(general_section)
        dialog.add(panels_section)
        dialog.add(search_section)
      end
    end

    private

      def general_section
        Adwaita::ShortcutsSection.new.tap do |section|
          section.title = "General"
          section.add(quit_item)
          section.add(search_item)
          section.add(help_item)
          section.add(shortcuts_item)
        end
      end

      def panels_section
        Adwaita::ShortcutsSection.new.tap do |section|
          section.title = "Panels"
          section.add(back_item)
        end
      end

      def search_section
        Adwaita::ShortcutsSection.new.tap do |section|
          section.title = "Search"
          section.add(cancel_search_item)
        end
      end

      def quit_item = Adwaita::ShortcutsItem.new("Quit", "<Control>Q")
      def search_item = Adwaita::ShortcutsItem.new("Search", "<Control>F")
      def help_item = action_item("Show help", "app.help")
      def shortcuts_item = action_item("Keyboard shortcuts", "app.shortcuts")
      def back_item = Adwaita::ShortcutsItem.new("Go back to previous panel", "<Alt>Left")
      def cancel_search_item = Adwaita::ShortcutsItem.new("Cancel search", "Escape")

      # The Ruby binding's two-positional-argument constructor always
      # resolves to the (title, accelerator) overload (confirmed against
      # the live gem this round), never the (title, action_name) one, so
      # an action-bound item is built with an empty accelerator and its
      # action name set explicitly afterwards.
      def action_item(title, action_name)
        Adwaita::ShortcutsItem.new(title, "").tap { |item| item.set_action_name(action_name) }
      end
  end
end
