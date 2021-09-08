require "rails_helper"

describe "ensuring frontmatter from content pages is rendered", type: :request do
  context "with an accordion layout" do
    before { get "/content-page" }

    subject { response.body }

    it { expect(response).to have_http_status(200) }

    [
      "Sample content page",
      "Step 1",
      "Step 2",
      "Introduction",
      "This is an alert",
      "Jump link 1",
      "Related content 1",
      "Right column CTA",
    ].each do |expected|
      it { is_expected.to include(expected) }
    end
  end

  context "with a different heading and title" do
    before { get "/custom-heading" }

    subject { response.body }

    let(:document) { Nokogiri.parse(response.body) }

    it { expect(response).to have_http_status(200) }

    specify "sets both the title and heading correctly" do
      expect(document.css("title").text).to end_with("Title goes here")
      expect(document.css("h1").text).to eql("Heading goes here")
    end
  end
end
