# frozen_string_literal: true

require "etc"
require "glib2"
require "gudev"

module GnomeControlCenter
  # SystemInfo gathers the hardware and software facts the About page shows:
  # hardware vendor/model and firmware version, memory and CPU, OS name and
  # architecture, and the kernel version.
  #
  # Ported from the data-gathering half of upstream's
  # panels/system/about/cc-about-page.c (get_hardware_model_string,
  # get_firmware_version_string, get_cpu_info, get_os_name, get_os_type,
  # get_kernel_version_string). Three deliberate substitutions, each noted
  # at its call site below:
  #
  #   * upstream reads hardware vendor/model/firmware through
  #     systemd-hostnamed's D-Bus properties (CcHostname); this port queries
  #     the same /sys/class/dmi/id data those properties are themselves
  #     read from, directly through the gudev gem, rather than adding a
  #     D-Bus round trip for the same sysfs facts;
  #   * upstream's get_cpu_info and the DMI/libgtop memory-size fallback go
  #     through libgtop's glibtop_get_sysinfo; libgtop's Ruby binding loads
  #     but its functions are not callable (confirmed this round — calling
  #     into it raises), so both read /proc directly instead, which is what
  #     libgtop itself does internally on Linux;
  #   * upstream's get_os_type reports the *build's* pointer width
  #     (GLIB_SIZEOF_VOID_P); this port has no native build step, so it
  #     reports the running kernel's machine architecture instead, which is
  #     the practical equivalent for a script-language port.
  #
  # Upstream's primary-disk-capacity figure (via UDisksClient) is left out
  # of this round: udisks's Ruby binding loads and exposes the UDisks
  # namespace, but UDisks::Client#object_manager itself raises
  # (GI_IS_OBJECT_INFO assertion failure) in this environment, independent
  # of whether udisksd is even running, so there is no reliable value to
  # show yet.
  class SystemInfo
    def initialize
      @dmi = GUdev::Client.new(["dmi"]).query_by_sysfs_path("/sys/class/dmi/id")
    rescue
      @dmi = nil
    end

    # Upstream's get_hardware_model_string.
    def hardware_model
      vendor = dmi_attr("sys_vendor")
      model = dmi_attr("product_name")
      vendor && model ? "#{vendor} #{model}" : "Unknown"
    end

    # Upstream's get_firmware_version_string.
    def firmware_version = dmi_attr("bios_version") || "Unknown"

    # Upstream's get_os_name: PRETTY_NAME, else "NAME VERSION_ID", else
    # "Unknown".
    def os_name
      name = GLib.get_os_info("NAME")
      version_id = GLib.get_os_info("VERSION_ID")
      GLib.get_os_info("PRETTY_NAME") || (name && version_id ? "#{name} #{version_id}" : "Unknown")
    end

    # Upstream's get_os_image_version.
    def os_build
      value = GLib.get_os_info("IMAGE_VERSION")
      value.nil? || value.empty? ? "Unknown" : value
    end

    # Upstream's get_os_type, substituting the running machine's
    # architecture for the build's pointer width (see class comment).
    def os_type
      machine = Etc.uname[:machine]
      %w[x86_64 aarch64 ppc64 ppc64le s390x riscv64].include?(machine) ? "64-bit" : "32-bit"
    end

    # Upstream's get_kernel_version_string: "<name> <release>", e.g.
    # "Linux 6.18.34".
    def kernel_version
      uname = Etc.uname
      "#{uname[:sysname]} #{uname[:release]}"
    end

    # Upstream's get_cpu_info: the unique "model name" values from the
    # CPUs, cleaned of marketing noise, each suffixed "x N" when more than
    # one core shares it.
    def processor
      models = File.readlines("/proc/cpuinfo", chomp: true)
                    .filter_map { |line| line[/\Amodel name\s*:\s*(.+)/, 1] }
      if models.empty?
        "Unknown"
      else
        models.tally.map { |model, count|
          cleaned = clean_cpu_model(model)
          count > 1 ? "#{cleaned} × #{count}" : cleaned
        }.join(" ")
      end
    end

    # Upstream's get_ram_size_dmi / get_ram_size_libgtop, formatted the way
    # upstream's g_format_size_full (G_FORMAT_SIZE_IEC_UNITS) would.
    def memory
      kib = File.read("/proc/meminfo")[/MemTotal:\s*(\d+)\s*kB/, 1]
      kib ? format_size_iec(kib.to_i * 1024) : "Unknown"
    end

    private

      def dmi_attr(name)
        value = @dmi&.then { |device| device.has_sysfs_attr?(name) ? device.get_sysfs_attr(name) : nil }
        value.nil? || value.empty? ? nil : value
      end

      # Upstream's info_cleanup: strips vendor marketing strings ruby-gnome
      # has no equivalent table for; this keeps the handful that show up on
      # every common CPU model string.
      def clean_cpu_model(model)
        model
          .gsub(/\((R|TM|C)\)/i, "")
          .gsub(/\s+CPU\b/, "")
          .gsub(/\s+@\s*[\d.]+\s*[GM]Hz\z/i, "")
          .gsub(/\s+/, " ")
          .strip
      end

      def format_size_iec(bytes)
        units = %w[B KiB MiB GiB TiB]
        steps = 0
        size = bytes.to_f
        while size >= 1024 && steps < units.size - 1
          size /= 1024
          steps += 1
        end
        format("%<size>.1f %<unit>s", size: size, unit: units[steps])
      end
  end
end
