require "rails_helper"

describe MetadataHelper, type: "helper" do
  describe "#meta_tag" do
    front_matter = [
      { provided: { key: "title", value: "A title" }, expected_name: "title" },
      { provided: { key: "description", value: "A description" }, expected_name: "description" },
      { provided: { key: "synopsis", value: "A synopsis", opengraph: true }, expected_name: "og:synopsis" },
    ]

    front_matter.each do |item|
      key   = item[:expected_name]
      value = item.dig(:provided, :value)

      specify "renders a meta tag for the #{key}" do
        rendered = Nokogiri.parse(meta_tag(**item[:provided])).at_css("meta")

        expect(rendered.name).to eql "meta"
        expect(rendered.attributes["name"].value).to eql(key)
        expect(rendered.attributes["content"].value).to eql(value)
      end
    end
  end

  describe "#image_meta_tags" do
    it "returns nil when not given an image_path" do
      expect(image_meta_tags(image_path: "")).to be_nil
    end

    it "returns image/alt meta tags when given an image_path" do
      tags = image_meta_tags(image_path: "static/images/content/blog/fellowship.jpg")

      expect(tags).to include(
        <<~HTML.chomp,
          <meta name="og:image" content="/packs-test/v1/static/images/content/blog/fellowship-14188f7670a9c10bf6d3.jpg">
        HTML
      )

      expect(tags).to include(
        <<~HTML.chomp,
          <meta name="og:image:alt" content="Teachers Mike and Phil play on a children&#39;s climbing frame in a playground">
        HTML
      )
    end

    it "uses asset_pack_url internally" do
      fake_host = "https://fake.com/123"

      allow_any_instance_of(described_class).to receive(:asset_pack_url) { fake_host }

      tags = image_meta_tags(image_path: "static/images/content/hero-images/0032.jpg")

      expect(tags).to match(fake_host)
    end
  end
end
