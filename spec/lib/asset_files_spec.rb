require "rails_helper"
require "asset_files"

describe AssetFiles do
  let(:logical) { "static/images/content/hero-images/teacher2.jpg" }
  let(:url_path) { Rails.application.assets.resolver.resolve(logical) }

  describe ".exist?" do
    it "finds dynamically served assets by their digested URL" do
      expect(described_class.exist?(url_path)).to be true
    end

    it "does not match a stale digest" do
      expect(described_class.exist?(url_path.sub(/-[0-9a-f]{8}\./, "-00000000."))).to be false
    end

    it "does not match unknown assets" do
      expect(described_class.exist?("/assets/static/images/nope.jpg")).to be false
    end
  end

  describe ".sibling_url_path" do
    it "returns the digested URL of a responsive sibling" do
      basename = url_path.sub(/-[0-9a-f]{8}\.jpg\z/, "")
      expected = Rails.application.assets.resolver.resolve("static/images/content/hero-images/teacher2--mobile.jpg")

      expect(described_class.sibling_url_path(basename, "--mobile", ".jpg")).to eq(expected)
    end
  end
end
