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
      expect(image_meta_tags(base_url: "https://example.com", image_path: "", alt: "")).to be_nil
    end

    it "returns image/alt meta tags when given an image_path" do
      tags = image_meta_tags(base_url: "https://example.com", image_path: "media/images/content/hero-images/0012.jpg", alt: "An image")

      expect(tags).to include(
        <<~HTML.chomp,
          <meta name="og:image" content="https://example.com/packs-test/v1/media/images/content/hero-images/0012-cb6435a02b879e8df922882afba620a8.jpg">
        HTML
      )

      expect(tags).to include(
        <<~HTML.chomp,
          <meta name="og:image:alt" content="An image">
        HTML
      )
    end
  end
end
