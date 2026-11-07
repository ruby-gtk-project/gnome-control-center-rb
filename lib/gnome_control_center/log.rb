# frozen_string_literal: true

module GnomeControlCenter
  # Log is the shell's own structured logger: domain-filtered, colorized
  # terminal output keyed off G_MESSAGES_DEBUG / a -v/-vv/-vvv verbosity
  # count, with a helper to anonymize free-text values (account names,
  # hostnames, …) before they are logged.
  #
  # Ported from upstream's shell/cc-log.c/.h. Upstream installs itself as
  # the process's GLib structured-log writer (g_log_set_writer_func), so
  # every g_log/g_debug/g_warning call anywhere in the C code — including
  # inside GTK/GLib itself — is filtered and formatted by this file.
  # ruby-gnome's GI bindings expose no equivalent hook (there is no
  # `GLib.log_set_writer_func`), so this port cannot intercept GLib's own
  # logging; what it keeps is everything callable directly: the domain/
  # verbosity filtering rules (.should_log?), the colorized line format
  # (.write), the verbosity counter (.increase_verbosity / .verbosity) and
  # the anonymization helper (.anonymize_value), all exposed as .log for
  # Ruby call sites that want upstream's cc_log() behaviour.
  module Log
    DEFAULT_DOMAIN_PREFIX = "cc"
    BLUETOOTH_DOMAIN_PREFIX = "Bluetooth"

    LEVEL_ORDER = %i[error critical warning message info debug trace].freeze

    COLORS = {
      error:    "\033[1;31m",
      critical: "\033[1;35m",
      warning:  "\033[1;33m",
      message:  "\033[1;32m",
      info:     "\033[1;32m",
      debug:    "\033[1;32m",
      trace:    "\033[1;36m",
    }.freeze

    LABELS = {
      error:    "   ERROR",
      critical: "CRITICAL",
      warning:  " WARNING",
      message:  " MESSAGE",
      info:     "    INFO",
      debug:    "   DEBUG",
      trace:    "   TRACE",
    }.freeze

    DOMAIN_COLORS = [
      "\033[1;32m", "\033[1;33m", "\033[1;35m", "\033[1;36m", "\033[1;91m",
      "\033[1;92m", "\033[1;93m", "\033[1;94m", "\033[1;95m", "\033[1;96m",
    ].freeze

    RESET = "\033[0m"

    def self.verbosity = @verbosity ||= 0

    # Upstream's cc_log_increase_verbosity, called once per -v on the
    # command line.
    def self.increase_verbosity
      @verbosity = verbosity + 1
    end

    # Upstream's cc_log_init: read G_MESSAGES_DEBUG once. "all" (or an
    # unset/empty variable) means every domain logs; a "no-anonymize" token
    # additionally disables #anonymize_value's redaction.
    def self.init
      return if @initialized

      raw = ENV["G_MESSAGES_DEBUG"]
      raw = nil if raw && raw.empty?

      if raw&.include?("no-anonymize")
        @any_domain = true
        @no_anonymize = true
        @domains = nil
      else
        @domains = raw
        @any_domain = raw.nil? || raw == "all"
      end

      @fatal_criticals = ENV["G_DEBUG"] == "fatal-criticals"
      @fatal_warnings = ENV["G_DEBUG"] == "fatal-warnings"

      @initialized = true
    end

    def self.any_domain? = @any_domain
    def self.domains = @domains
    def self.no_anonymize? = !!@no_anonymize
    def self.fatal_criticals? = !!@fatal_criticals
    def self.fatal_warnings? = !!@fatal_warnings

    # Upstream's cc_log: filters through #should_log?, then formats and
    # writes through #write. Errors and criticals, like upstream's
    # G_LOG_FLAG_FATAL handling, raise after being logged.
    def self.log(domain, level, message, value: nil, stream: nil)
      return if message.nil? || message.empty?
      return unless should_log?(domain, level)

      full_message = value.nil? || value.empty? ? message : "#{message} #{anonymize_value(value)}"
      write(domain, level, full_message, stream: stream)
    end

    # Upstream's should_log: domain and verbosity filtering, independent of
    # message formatting.
    def self.should_log?(domain, level)
      init
      return true if %i[error critical warning].include?(level)

      if any_domain? && domains
        return true unless level == :trace
        return verbosity >= 2
      end

      if domains.nil? && (domain.start_with?(DEFAULT_DOMAIN_PREFIX) || domain.start_with?(BLUETOOTH_DOMAIN_PREFIX))
        return show_for_level?(level)
      end

      if domains && matches_domain?(domains, domain)
        return show_for_level?(level)
      end

      return false if domains

      if verbosity < 4 && %w[GdkPixbuf Gvc].include?(domain)
        return false
      end

      verbosity >= 3
    end

    # Upstream's cc_log_anonymize_value: replace every alphanumeric
    # codepoint that is not the first/last character of a run with '#',
    # so "JohnSmith123" becomes "J#######23"-shaped output while
    # punctuation and the run boundaries stay visible. Returns the
    # original value unchanged when .no_anonymize? or the value is not
    # valid UTF-8 is approximated here by rescue-ing to "******".
    def self.anonymize_value(value)
      init
      return value if value.nil? || value.empty?
      return value if no_anonymize?

      chars = value.each_char.to_a
      chars.each_with_index.map do |c, i|
        prev_alnum = i > 0 && chars[i - 1] =~ /[[:alnum:]]/
        next_alnum = i < chars.size - 1 && chars[i + 1] =~ /[[:alnum:]]/
        alnum = c =~ /[[:alnum:]]/

        if !alnum || !prev_alnum || !next_alnum
          c
        else
          "#"
        end
      end.join
    rescue ArgumentError
      "******"
    end

    # Upstream's cc_log_write: one colorized "HH:MM:SS.mmmm      domain
    # [pid]:    LEVEL: message" line, errors/criticals/warnings to
    # $stderr and everything else to $stdout.
    def self.write(domain, level, message, stream: nil)
      stream ||= %i[error critical warning].include?(level) ? $stderr : $stdout
      color = stream.respond_to?(:tty?) && stream.tty?

      now = Time.now
      time = now.strftime("%H:%M:%S.") + format("%04d", now.usec / 100)

      domain_field = color ? "#{domain_color(domain)}#{domain.rjust(20)}#{RESET}" : domain.rjust(20)
      level_field = color ? "#{COLORS.fetch(level, "")}#{LABELS.fetch(level, " UNKNOWN")}#{RESET}" : LABELS.fetch(level, " UNKNOWN")

      stream.puts("#{time} #{domain_field} [#{Process.pid}]: #{level_field}: #{message}")
      stream.flush

      fatal = level == :error ||
        (fatal_criticals? && level == :critical) ||
        (fatal_warnings? && %i[critical warning].include?(level))

      raise "#{domain}: #{message}" if fatal
    end

    def self.domain_color(domain)
      DOMAIN_COLORS[domain.sum % DOMAIN_COLORS.size]
    end
    private_class_method :domain_color

    def self.show_for_level?(level)
      return true if verbosity >= 3
      return verbosity >= 2 if level == :trace
      return verbosity >= 1 if level == :debug

      true
    end
    private_class_method :show_for_level?

    def self.matches_domain?(log_domains, domain)
      return false if log_domains.nil? || log_domains.empty? || domain.nil? || domain.empty?

      log_domains.split(/[,\s]+/).any? { |d| !d.empty? && domain.start_with?(d) }
    end
    private_class_method :matches_domain?
  end
end
