require "rails_helper"

describe CookiePreferencesController, type: :request do
  describe "#show" do
    let(:referer) { nil }

    before { get cookie_preference_path, params: {}, headers: { "HTTP_REFERER" => referer } }

    subject { response }

    it { is_expected.to have_http_status :success }
    it { is_expected.not_to be_indexed }
    it { expect(response.body).to match "Cookie settings" }
    it { expect(response.body).to include("Go to home page") }
    it { expect(response.body).not_to include("Live chat") }

    context "when there is an internal referrer" do
      let(:referer) { "http://www.example.com/train-to-be-a-teacher" }

      it { expect(response.body).to include("Back to page") }
    end
  end
end
