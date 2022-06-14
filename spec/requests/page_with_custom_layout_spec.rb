require "rails_helper"

describe "rendering pages with a custom layout", type: :request do
  context "with a home page layout" do
    subject { response.body }

    before { get "/home-page" }

    it { expect(response).to have_http_status(:ok) }
    it { is_expected.to include("Home Page Test") }

    it { is_expected.to include("Discover the steps to become a teacher") }
    it { is_expected.to include("Check your qualifications") }
  end
end
