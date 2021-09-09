require "rails_helper"

describe "External link images", type: :request do
  excluded_classes = %w[button]
  subject { response.body }

  before { get "/ways-to-train" }

  context "when external link and not #{excluded_classes.join(' ')}" do
    it "adds an external link icon" do
      doc = Nokogiri::HTML.parse(response.body)
      markdown_links = doc.css(".markdown a")
      markdown_links.each do |anchor|
        classes = anchor.attr("class")&.split
        if anchor[:href].include?("//") && !classes&.difference(excluded_classes)
          expect(anchor.children.at("img").to_html).to include('class="external-link-icon')
          expect(anchor.children.at("img").to_html).to include('alt=""')
        end
      end
    end
  end
end
