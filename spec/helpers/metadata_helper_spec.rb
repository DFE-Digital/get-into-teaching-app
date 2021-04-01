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
end
