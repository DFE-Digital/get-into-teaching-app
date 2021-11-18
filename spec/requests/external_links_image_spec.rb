require "rails_helper"

describe "External link images", type: :request do
  excluded_classes = %w[button]

  subject(:markdown_links) do
    get path
    doc = Nokogiri::HTML.parse(response.body)
    doc.css(".markdown a")
  end

  context "when external link and not #{excluded_classes.join(' ')}" do
    it "adds an external link icon" do
      markdown_links.each do |anchor|
        classes = anchor.attr("class")&.split
        if anchor[:href].include?("//") && !classes&.difference(excluded_classes)
          expect(anchor.children.at("img").to_html).to include('class="external-link-icon')
          expect(anchor.children.at("img").to_html).to include('alt=""')
        end
      end
    end
  end

  context "when a link to an internal asset hosted on an external domain" do
    before do
      allow(ENV).to receive(:[]).and_call_original
      allow(ENV).to receive(:[]).with("APP_ASSETS_URL").and_return("https://external-asset.domain")
    end

    let(:path) { "/test" }

    it "does not add an external link icon" do
      markdown_links.each do |anchor|
        expect(anchor.children.at("img")).to be_nil
      end
    end
  end
end
