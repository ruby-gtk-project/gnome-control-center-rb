# frozen_string_literal: true

require "gio2"

module GnomeControlCenter
  # ObjectStorage is a process-wide cache of GObjects (chiefly D-Bus proxies)
  # keyed by a plain string id, so panels that want the same proxy — the
  # NetworkManager client, the hostname proxy, the ModemManager manager, the
  # pwquality GSettings object — share one instance instead of each opening
  # its own.
  #
  # Ported from upstream's shell/cc-object-storage.c/.h. Upstream is a
  # process-wide singleton GObject created once via #initialize and torn
  # down once via #destroy, with every other method asserting that the
  # singleton exists; the cache itself is a GHashTable from string to
  # GObject. This port keeps the singleton shape (the module itself stands
  # in for the one `_instance`) and the same cache semantics, but drops the
  # async create_dbus_proxy/_finish pair — upstream's two-call GTask dance
  # exists only because GDBusProxy construction in C has a sync and an
  # async entry point; this port only ever needs the synchronous one.
  module ObjectStorage
    # Upstream's CC_OBJECT_NMCLIENT / CC_OBJECT_HOSTNAME / CC_OBJECT_MMMANAGER
    # / CC_OBJECT_PWQ_SETTINGS default storage keys.
    NMCLIENT = "CcObjectStorage::nm-client"
    HOSTNAME = "CcObjectStorage::hostname"
    MMMANAGER = "CcObjectStorage::mm-manager"
    PWQ_SETTINGS = "CcObjectStorage::pw-quality-settings"

    def self.store = @store ||= {}

    # Upstream's cc_object_storage_initialize: must be called only once,
    # before every other method. This port's @store is created lazily by
    # #store itself, so #initialize only needs to guard against being
    # called twice.
    def self.initialize_storage
      raise "ObjectStorage already initialized" if @initialized

      store
      @initialized = true
    end

    # Upstream's cc_object_storage_destroy.
    def self.destroy
      raise "ObjectStorage not initialized" unless @initialized

      @store = nil
      @initialized = false
    end

    # Upstream's cc_object_storage_has_object.
    def self.has_object?(key) = store.key?(key)

    # Upstream's cc_object_storage_add_object. It is a programming error to
    # add an object under a key that is already stored.
    def self.add_object(key, object)
      raise ArgumentError, "object already stored for key: #{key}" if has_object?(key)

      store[key] = object
    end

    # Upstream's cc_object_storage_get_object. It is a programming error to
    # fetch a key that was never added; callers check #has_object? first.
    def self.get_object(key)
      raise ArgumentError, "no object stored for key: #{key}" unless has_object?(key)

      store[key]
    end

    # Upstream's cc_object_storage_create_dbus_proxy_sync: create (or reuse
    # a cached) Gio::DBusProxy for the given bus name/path/interface. The
    # cache key mirrors upstream's "CcObjectStorage::dbus-proxy(name,path,interface)".
    def self.create_dbus_proxy_sync(bus_type, flags, name, path, interface, cancellable: nil)
      key = "CcObjectStorage::dbus-proxy(#{name},#{path},#{interface})"

      return get_object(key) if has_object?(key)

      proxy = Gio::DBusProxy.new(bus_type, flags, nil, name, path, interface, cancellable)

      add_object(key, proxy)
      proxy
    end
  end
end
