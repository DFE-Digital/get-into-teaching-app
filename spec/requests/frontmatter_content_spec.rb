require "rails_helper"

describe "ensuring frontmatter from content pages is rendered", type: :request do
  context "with an full layout" do
    subject { response.body }

    before { get "/content-page" }

    it { expect(response).to have_http_status(:ok) }

    [
      "Sample content page",
      "Introduction",
      "This is an alert",
    ].each do |expected|
      it { is_expected.to include(expected) }
    end
  end

  context "with a different heading and title" do
    subject { response.body }

    before { get "/custom-heading" }

    let(:document) { Nokogiri.parse(response.body) }

    it { expect(response).to have_http_status(:ok) }

    specify "sets both the title and heading correctly" do
      expect(document.css("title").text).to start_with("Title goes here")
      expect(document.css("h1").text).to include("Heading goes here")
    end
  end
end
