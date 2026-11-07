# frozen_string_literal: true

module GnomeControlCenter
  module Panels
    module Common
      # Small string/date helpers shared across panels.
      #
      # Ported from upstream's panels/common/cc-util.c / cc-util.h.
      module Util
        # Combining diacritical marks and the soft hyphen, the same ranges
        # upstream's IS_CDM_UCS4 / IS_SOFT_HYPHEN macros strip after NFKD
        # normalization and casefolding.
        COMBINING_MARKS_AND_SOFT_HYPHEN = /[̀-ͯ᷀-᷿⃐-⃿︠-︯­]/

        # Upstream's cc_util_normalize_casefold_and_unaccent: NFKD-normalize,
        # casefold, then drop combining diacritical marks and the soft
        # hyphen so accented text compares equal to its unaccented form.
        def self.normalize_casefold_and_unaccent(str)
          str&.unicode_normalize(:nfkd)&.downcase&.gsub(COMBINING_MARKS_AND_SOFT_HYPHEN, "")
        end

        # Upstream's cc_util_get_smart_date: "Today"/"Yesterday" for the
        # last two days, "Feb 24" for this year, "Feb 24, 2013" otherwise.
        def self.get_smart_date(date)
          return nil if date.nil?

          today = Time.now.to_date
          span_days = (today - date.to_date).to_i

          if span_days <= 0
            "Today"
          elsif span_days <= 1
            "Yesterday"
          elsif date.year == today.year
            date.strftime("%b %-e")
          else
            date.strftime("%b %-e, %Y")
          end
        end

        # Upstream's cc_util_get_smart_date_time: the smart date plus the
        # locale's time-of-day, e.g. "Today, 10:10:10 AM".
        def self.get_smart_date_time(date)
          return nil if date.nil?

          "#{get_smart_date(date)}, #{date.strftime("%X")}"
        end

        # Upstream's cc_util_time_to_string_text: a duration in milliseconds
        # rendered as "5 hours 2 minutes 12 seconds", dropping any unit
        # that's zero, down to "0 seconds" when the whole thing is zero.
        def self.time_to_string_text(msecs)
          total_seconds = (msecs / 1000).to_i
          sec = total_seconds % 60
          min = (total_seconds / 60) % 60
          hour = total_seconds / 3600

          parts = []
          parts << pluralize(hour, "hour", "hours") if hour > 0
          parts << pluralize(min, "minute", "minutes") if min > 0
          parts << pluralize(sec, "second", "seconds") if sec > 0

          parts.empty? ? "0 seconds" : parts.join(" ")
        end

        # Upstream's cc_util_app_id_to_display_name: the desktop file's
        # display name, falling back to the raw app id when there is no
        # matching .desktop file.
        #
        # Upstream reaches this through GDesktopAppInfo, whose GI typelib
        # (GioUnix-2.0) the gio2 gem does not load — it stays on the
        # GLib-only surface GioUnix sits behind. The desktop file itself is
        # a fixed, documented format (freedesktop.org Desktop Entry Spec),
        # so this reads the "Name=" key directly from XDG_DATA_DIRS rather
        # than hand-rolling a GAppInfo substitute.
        def self.app_id_to_display_name(app_id)
          desktop_file = find_desktop_file("#{app_id}.desktop")

          return app_id if desktop_file.nil?

          name_line = File.readlines(desktop_file).find { |line| line.start_with?("Name=") }
          name_line ? name_line.sub("Name=", "").strip : app_id
        end

        def self.find_desktop_file(basename)
          data_dirs = ENV.fetch("XDG_DATA_DIRS", "/usr/local/share:/usr/share").split(":")
          data_dirs.map { |dir| File.join(dir, "applications", basename) }.find { |path| File.exist?(path) }
        end
        private_class_method :find_desktop_file

        # Upstream's cc_util_get_localized_weekday_name: the locale's name
        # for an ISO weekday number (Monday: 1, Sunday: 7). 1970-01-04 was a
        # Sunday, the same anchor upstream uses.
        def self.get_localized_weekday_name(iso_weekday_number)
          first_sunday = Time.utc(1970, 1, 4)
          (first_sunday + (iso_weekday_number * 86_400)).strftime("%A")
        end

        def self.pluralize(count, singular, plural)
          "#{count} #{count == 1 ? singular : plural}"
        end
        private_class_method :pluralize
      end
    end
  end
end
