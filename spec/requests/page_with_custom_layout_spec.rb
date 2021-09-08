require "rails_helper"

describe "rendering pages with a custom layout", type: :request do
  context "with a home page layout" do
    before { get "/home-page" }

    subject { response.body }

    it { expect(response).to have_http_status(200) }
    it { is_expected.to include("Home Page Test") }

    it { is_expected.to include("Discover the steps to become a teacher") }
    it { is_expected.to include("Check your qualifications") }
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

    it { is_expected.to include("A heading") }
    it { is_expected.to include("A subheading") }
    it { is_expected.to include("Longer featured page text") }

    it { is_expected.to include("A Section") }
    it { is_expected.to include("Longer section text") }

    it { is_expected.to include("Section story") }
    it { is_expected.to include("A snippet") }
  end
end
