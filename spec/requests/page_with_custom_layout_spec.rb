require "rails_helper"

describe "rendering pages with a custom layout" do
  include_context "prepend fake views"

  context "with an accordion layout" do
    before { get "/accordion" }
    subject { response }

    it { is_expected.to have_http_status(200) }
    it { expect(response.body).to include("Accordion Test") }
    it { expect(response.body).to include("Step 1") }
    it { expect(response.body).to include("Step 2") }
  end
end
