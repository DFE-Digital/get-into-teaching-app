require "rails_helper"

describe "rendering pages with a custom layout" do
  include_context "prepend fake views"

  context "with an accordion layout" do
    before { get "/accordion-page" }
    subject { response.body }

    it { expect(response).to have_http_status(200) }
    it { is_expected.to include("Accordion Page Test") }
    it { is_expected.to include("Step 1") }
    it { is_expected.to include("Step 2") }
  end

  context "with a stories/story layout" do
    before { get "/stories/story-page" }
    subject { response.body }

    it { expect(response).to have_http_status(200) }
    it { is_expected.to include("Story Page Test") }
    it { is_expected.to include("John Doe") }
    it { is_expected.to include("Head of Everything") }
  end

  context "with a stories/list layout" do
    before { get "/stories/list-page" }
    subject { response.body }

    it { expect(response).to have_http_status(200) }
    it { is_expected.to include("List Page Test") }

    it { is_expected.to include("Story") }
    it { is_expected.to include("Story snippet") }

    it { is_expected.to include("Some content") }
  end

  context "with a stories/landing layout" do
    before { get "/stories/landing-page" }
    subject { response.body }

    it { expect(response).to have_http_status(200) }
    it { is_expected.to include("Landing Page Test") }

    it { is_expected.to include("Featured story") }
    it { is_expected.to include("A heading") }
    it { is_expected.to include("A subheading") }
    it { is_expected.to include("Longer featured story text") }

    it { is_expected.to include("A Section") }
    it { is_expected.to include("Longer section text") }

    it { is_expected.to include("Section story") }
    it { is_expected.to include("A snippet") }
  end
end
