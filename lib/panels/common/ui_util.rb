# frozen_string_literal: true

require "gtk4"

module GnomeControlCenter
  module Panels
    module Common
      # Keyboard-navigation helpers that bounce a widget's focus request up
      # to its root window rather than letting it fall through to a sibling.
      #
      # Ported from upstream's panels/common/cc-ui-util.c / cc-ui-util.h.
      module UiUtil
        # Upstream's cc_util_keynav_propagate_vertical: forwards Up/Down
        # focus moves to the root as a tab-order move, so a widget at the
        # edge of its own focus chain (e.g. the last row of a listbox) lets
        # the window's overall tab order take over instead of the move being
        # swallowed.
        def self.keynav_propagate_vertical(widget, direction)
          root = widget.root

          return false if root.nil?

          case direction
          when :up
            root.child_focus(:tab_backward)
          when :down
            root.child_focus(:tab_forward)
          else
            false
          end
        end

        # Upstream's cc_util_keynav_propagate_up: only the Up direction is
        # forwarded; Down is left for the widget's own focus chain.
        def self.keynav_propagate_up(widget, direction)
          root = widget.root

          return false if root.nil?

          direction == :up ? root.child_focus(:tab_backward) : false
        end
      end
    end
  end
end
