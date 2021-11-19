require "rails_helper"

describe CookiePreferencesController, type: :request do
  describe "#show" do
    let(:referer) { nil }

    before { get cookie_preference_path, params: {}, headers: { "HTTP_REFERER" => referer } }

    it { expect(response).to have_http_status :success }
    it { expect(response.body).to match "Cookie settings" }
    it { expect(response.body).to include("Go to home page") }
    it { expect(response.body).not_to include("Live chat") }

    context "when there is an internal referrer" do
      let(:referer) { "http://www.example.com/ways-to-train" }

      it { expect(response.body).to include("Back to page") }
    end
  end
end
