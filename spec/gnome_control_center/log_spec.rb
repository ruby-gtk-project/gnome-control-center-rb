# frozen_string_literal: true

require "gnome_control_center/log"

# Ported from upstream's shell/cc-log.c/.h (see the module comment in
# lib/gnome_control_center/log.rb for what this port keeps and what it
# cannot, since ruby-gnome exposes no g_log_set_writer_func hook).
RSpec.describe GnomeControlCenter::Log do
  # Log is a module-level singleton (verbosity/domains/etc. are instance
  # variables on the module itself), so every example resets it to a known
  # state rather than relying on run order.
  around do |example|
    described_class.instance_variable_set(:@initialized, false)
    described_class.instance_variable_set(:@verbosity, 0)
    described_class.instance_variable_set(:@domains, nil)
    described_class.instance_variable_set(:@any_domain, nil)
    described_class.instance_variable_set(:@no_anonymize, nil)
    described_class.instance_variable_set(:@fatal_criticals, nil)
    described_class.instance_variable_set(:@fatal_warnings, nil)

    original_debug = ENV["G_MESSAGES_DEBUG"]
    original_g_debug = ENV["G_DEBUG"]
    begin
      example.run
    ensure
      ENV["G_MESSAGES_DEBUG"] = original_debug
      ENV["G_DEBUG"] = original_g_debug
    end
  end

  describe ".anonymize_value" do
    it "masks interior alphanumerics, keeping the first/last character of a run" do
      expect(described_class.anonymize_value("JohnSmith123")).to eq("J##########3")
    end

    it "leaves punctuation and non-alphanumeric boundaries untouched" do
      expect(described_class.anonymize_value("a.b")).to eq("a.b")
    end

    it "returns an empty value unchanged" do
      expect(described_class.anonymize_value("")).to eq("")
    end

    it "does not anonymize when G_MESSAGES_DEBUG contains no-anonymize" do
      ENV["G_MESSAGES_DEBUG"] = "no-anonymize"
      expect(described_class.anonymize_value("JohnSmith123")).to eq("JohnSmith123")
    end
  end

  describe ".should_log?" do
    it "always logs error/critical/warning, regardless of domain filtering" do
      ENV["G_MESSAGES_DEBUG"] = "SomeOtherDomain"
      expect(described_class.should_log?("cc-unrelated", :error)).to be(true)
      expect(described_class.should_log?("cc-unrelated", :critical)).to be(true)
      expect(described_class.should_log?("cc-unrelated", :warning)).to be(true)
    end

    it "shows cc-prefixed info by default with no G_MESSAGES_DEBUG set" do
      ENV.delete("G_MESSAGES_DEBUG")
      expect(described_class.should_log?("cc-shell", :info)).to be(true)
    end

    it "hides debug-level cc messages until -v raises verbosity" do
      ENV.delete("G_MESSAGES_DEBUG")
      expect(described_class.should_log?("cc-shell", :debug)).to be(false)
      described_class.increase_verbosity
      expect(described_class.should_log?("cc-shell", :debug)).to be(true)
    end

    it "hides a domain outside cc/Bluetooth with nothing set" do
      ENV.delete("G_MESSAGES_DEBUG")
      expect(described_class.should_log?("SomeRandomLib", :info)).to be(false)
    end

    it "honours an explicit domain list, prefix-matched" do
      ENV["G_MESSAGES_DEBUG"] = "SomeRandomLib"
      expect(described_class.should_log?("SomeRandomLib-sub", :info)).to be(true)
      expect(described_class.should_log?("cc-shell", :info)).to be(false)
    end
  end

  describe ".increase_verbosity / .verbosity" do
    it "starts at zero and counts one per call" do
      expect(described_class.verbosity).to eq(0)
      described_class.increase_verbosity
      described_class.increase_verbosity
      expect(described_class.verbosity).to eq(2)
    end
  end

  describe ".log" do
    it "writes a formatted line to the given stream for a level that passes the filter" do
      ENV.delete("G_MESSAGES_DEBUG")
      out = StringIO.new
      described_class.log("cc-shell", :info, "hello", stream: out)
      expect(out.string).to include("hello")
      expect(out.string).to include("INFO")
      expect(out.string).to include("cc-shell")
    end

    it "appends the anonymized value when one is given" do
      ENV.delete("G_MESSAGES_DEBUG")
      out = StringIO.new
      described_class.log("cc-shell", :info, "user", value: "JohnSmith", stream: out)
      expect(out.string).to include("J#######h")
      expect(out.string).not_to include("JohnSmith")
    end

    it "writes nothing for a message the filter rejects" do
      ENV.delete("G_MESSAGES_DEBUG")
      out = StringIO.new
      described_class.log("UnfilteredDomain", :info, "hidden", stream: out)
      expect(out.string).to eq("")
    end

    it "writes nothing for a nil or empty message" do
      ENV.delete("G_MESSAGES_DEBUG")
      out = StringIO.new
      described_class.log("cc-shell", :info, "", stream: out)
      described_class.log("cc-shell", :info, nil, stream: out)
      expect(out.string).to eq("")
    end
  end

  describe ".write" do
    it "raises after writing an error-level line, as upstream's G_LOG_FLAG_FATAL does" do
      out = StringIO.new
      expect { described_class.write("cc-shell", :error, "boom", stream: out) }
        .to raise_error(RuntimeError, "cc-shell: boom")
      expect(out.string).to include("boom")
    end

    it "does not raise for a plain warning" do
      out = StringIO.new
      expect { described_class.write("cc-shell", :warning, "careful", stream: out) }
        .not_to raise_error
    end

    it "raises on critical only once G_DEBUG=fatal-criticals is set" do
      out = StringIO.new
      described_class.init
      expect { described_class.write("cc-shell", :critical, "oops", stream: out) }
        .not_to raise_error

      described_class.instance_variable_set(:@fatal_criticals, true)
      expect { described_class.write("cc-shell", :critical, "oops", stream: out) }
        .to raise_error(RuntimeError, "cc-shell: oops")
    end
  end

  describe ".init" do
    it "is idempotent" do
      ENV["G_MESSAGES_DEBUG"] = "all"
      described_class.init
      expect(described_class.any_domain?).to be(true)
      ENV["G_MESSAGES_DEBUG"] = "SomethingElse"
      described_class.init
      # init already ran once; the second call is a no-op, so the first
      # ENV read (all -> any_domain = true) is still what is in effect.
      expect(described_class.any_domain?).to be(true)
    end
  end
end
