# frozen_string_literal: true

require "gnome_control_center/object_storage"

# Ported from upstream's shell/cc-object-storage.c/.h (see the module
# comment in lib/gnome_control_center/object_storage.rb for what changed
# in the port: the singleton shape and cache semantics are kept, the
# async create_dbus_proxy/_finish pair is dropped).
RSpec.describe GnomeControlCenter::ObjectStorage do
  # ObjectStorage is a module-level singleton, so every example resets it
  # to a known, uninitialized state rather than relying on run order.
  around do |example|
    described_class.instance_variable_set(:@store, nil)
    described_class.instance_variable_set(:@initialized, false)
    example.run
    described_class.instance_variable_set(:@store, nil)
    described_class.instance_variable_set(:@initialized, false)
  end

  describe ".initialize_storage / .destroy" do
    it "raises if initialized twice" do
      described_class.initialize_storage
      expect { described_class.initialize_storage }
        .to raise_error(RuntimeError, "ObjectStorage already initialized")
    end

    it "raises if destroyed without having been initialized" do
      expect { described_class.destroy }
        .to raise_error(RuntimeError, "ObjectStorage not initialized")
    end

    it "clears the store on destroy" do
      described_class.initialize_storage
      described_class.add_object("k", :v)
      described_class.destroy
      described_class.initialize_storage
      expect(described_class.has_object?("k")).to be(false)
    end
  end

  describe ".add_object / .get_object / .has_object?" do
    before { described_class.initialize_storage }

    it "stores and retrieves an object by key" do
      object = Object.new
      described_class.add_object("key", object)
      expect(described_class.has_object?("key")).to be(true)
      expect(described_class.get_object("key")).to equal(object)
    end

    it "reports false for a key never added" do
      expect(described_class.has_object?("missing")).to be(false)
    end

    it "refuses to add a second object under the same key" do
      described_class.add_object("key", :first)
      expect { described_class.add_object("key", :second) }
        .to raise_error(ArgumentError, "object already stored for key: key")
      expect(described_class.get_object("key")).to eq(:first)
    end

    it "refuses to fetch a key that was never added" do
      expect { described_class.get_object("missing") }
        .to raise_error(ArgumentError, "no object stored for key: missing")
    end
  end

  describe "default storage keys" do
    it "match upstream's CC_OBJECT_* constants" do
      expect(described_class::NMCLIENT).to eq("CcObjectStorage::nm-client")
      expect(described_class::HOSTNAME).to eq("CcObjectStorage::hostname")
      expect(described_class::MMMANAGER).to eq("CcObjectStorage::mm-manager")
      expect(described_class::PWQ_SETTINGS).to eq("CcObjectStorage::pw-quality-settings")
    end
  end

  describe ".create_dbus_proxy_sync" do
    before { described_class.initialize_storage }

    it "caches the proxy under a key naming the bus name/path/interface" do
      proxy = described_class.create_dbus_proxy_sync(
        :session,
        0,
        "org.freedesktop.DBus",
        "/org/freedesktop/DBus",
        "org.freedesktop.DBus",
      )
      expect(proxy).to be_a(Gio::DBusProxy)
      key = "CcObjectStorage::dbus-proxy(org.freedesktop.DBus,/org/freedesktop/DBus,org.freedesktop.DBus)"
      expect(described_class.has_object?(key)).to be(true)
      expect(described_class.get_object(key)).to equal(proxy)
    end

    it "returns the same cached proxy on a second call for the same name/path/interface" do
      first = described_class.create_dbus_proxy_sync(
        :session, 0, "org.freedesktop.DBus", "/org/freedesktop/DBus", "org.freedesktop.DBus"
      )
      second = described_class.create_dbus_proxy_sync(
        :session, 0, "org.freedesktop.DBus", "/org/freedesktop/DBus", "org.freedesktop.DBus"
      )
      expect(second).to equal(first)
    end
  end
end
