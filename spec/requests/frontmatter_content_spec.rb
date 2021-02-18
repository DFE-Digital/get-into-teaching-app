require "rails_helper"

describe "ensuring frontmatter from content pages is rendered" do
  include_context "prepend fake views"

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
end
