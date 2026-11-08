# frozen_string_literal: true

require "etc"
require "glib2"
require "gio2"
require "gudev"
require "udisks"
require_relative "object_storage"

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
  # Upstream's primary-disk-capacity figure (get_primary_disk_info) goes
  # through UDisksClient's GDBusObjectManager (udisks_client_get_object_manager
  # + g_dbus_object_manager_get_objects), summing non-removable drives'
  # sizes. That path is NOT callable through this binding: UDisks::Client's
  # #object_manager (and UDisks::ObjectManagerClient#get_object/get_interface)
  # raise `g_object_info_get_ref_function_pointer: assertion
  # 'GI_IS_OBJECT_INFO (info)' failed`, independent of whether udisksd is
  # running — gobject-introspection cannot resolve the dynamically-typed
  # GDBusObject/GDBusInterface return values this API relies on. Instead,
  # #disk_capacity below calls org.freedesktop.UDisks2.Manager directly
  # through a plain UDisks::ManagerProxy (a generated GDBusProxy, whose
  # methods have concrete typed signatures the binding CAN resolve) and
  # resolves each returned drive object path with UDisks::DriveProxy. This
  # is real UDisks usage, not a workaround: it is the same D-Bus interface
  # upstream's libudisks2 itself calls underneath udisks_client_new_sync.
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

    # Upstream's get_primary_disk_info: the summed size of every drive that
    # is neither removable nor ejectable, queried through
    # org.freedesktop.UDisks2.Manager over the system bus (see the class
    # comment for why this goes through UDisks::ManagerProxy rather than
    # UDisks::Client). Returns "Unknown" when udisksd is not reachable or no
    # matching drive is found, matching upstream's UI fallback.
    def disk_capacity
      total = udisks_drives.sum { |drive|
        (!drive.removable? && !drive.ejectable?) ? drive.size : 0
      }
      total > 0 ? format_size_iec(total) : "Unknown"
    rescue
      "Unknown"
    end

    private

      # org.freedesktop.UDisks2.Manager.GetDrives, resolved to live
      # UDisks::DriveProxy instances. `{}` is UDisks2's `(a{sv})` options
      # parameter — always empty for this call. The manager proxy itself
      # is cached in ObjectStorage under upstream's own
      # "CcObjectStorage::udisks-manager"-shaped key, the same way
      # upstream's cc_object_storage_create_dbus_proxy_sync would hold one
      # instance for every panel that asks, rather than opening a fresh
      # D-Bus proxy per call.
      def udisks_drives
        no_options = GLib::Variant.parse("{}", "a{sv}")
        udisks_manager.call_get_drives_sync(no_options).map { |path|
          UDisks::DriveProxy.new(:system, 0, "org.freedesktop.UDisks2", path)
        }
      rescue
        []
      end

      def udisks_manager
        key = "CcObjectStorage::udisks-manager"
        if ObjectStorage.has_object?(key)
          ObjectStorage.get_object(key)
        else
          ObjectStorage.add_object(key, UDisks::ManagerProxy.new(:system, 0, "org.freedesktop.UDisks2", "/org/freedesktop/UDisks2/Manager"))
        end
      end

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
