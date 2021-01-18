require "rails_helper"

describe PagesController do
  describe "#show" do
    include_context "always render testing page"

    context "without caching enabled" do
      it "Should not have cache headers" do
        get "/test"

        expect(response).to have_http_status 200
        expect(response.headers).not_to include "Last-Modified"
        expect(response.headers["Cache-control"]).to match %r{max-age=0}
        expect(response.headers["Cache-control"]).to match %r{private}
        expect(response.headers["Cache-control"]).to match %r{must-revalidate}
      end
    end

    context "with caching" do
      let(:cache_config) { Rails.application.config.x.static_pages }

      before do
        allow(Rails.application.config.action_controller).to \
          receive(:perform_caching).and_return true

        allow(cache_config).to receive(:etag).and_return "12345"
        allow(cache_config).to receive(:last_modified).and_return 2.minutes.ago
      end

      it "should utilise cached version" do
        get "/test"
        expect(response).to have_http_status 200

        etag = response.headers["ETag"]
        lastmod = response.headers["Last-Modified"]

        expect(lastmod).not_to be_nil

        get "/test", headers: {
          "If-None-Match" => etag,
          "If-Modified-Since" => lastmod,
        }

        expect(response).to have_http_status 304
      end
    end

    context "with unknown page" do
      let(:template) { "testing/unknown" }
      before { get "/test" }
      subject { response }
      it { is_expected.to have_http_status :not_found }
      it { is_expected.to have_attributes body: %r{Page not found} }
    end

    context "with cookies page" do
      before { get "/cookies" }
      subject { response }
      it { is_expected.to have_http_status(:success) }
    end

    context "with invalid page page" do
      let(:template) { "../../secrets.txt" }
      before { get "/test" }
      subject { response }
      it { is_expected.to have_http_status :not_found }
      it { is_expected.to have_attributes body: %r{Page not found} }
    end
  end

  describe "rendering a page that has a .../index template" do
    include_context "prepend fake views"

    it "returns the template at <template>/index if the request is just for <template>" do
      get "/test"
      expect(response).to have_http_status(:success)
      expect(response.body).to include("Index Page Test")
    end

    it "returns 404 if <template>/index is requested directly" do
      get "/test/index"
      expect(response).to have_http_status(:not_found)
    end

    it "returns 404 if there is no <template>/index and the request is just for <template>" do
      get "/stories"
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "redirect to TTA site" do
    include_context "stub env vars", "TTA_SERVICE_URL" => "https://tta-service/"
    subject { response }

    context "with /tta-service url" do
      before { get "/tta-service" }
      it { is_expected.to redirect_to "https://tta-service/" }
    end

    context "with /tta url" do
      before { get "/tta" }
      it { is_expected.to redirect_to "https://tta-service/" }
    end

    context "with utm params" do
      before { get "/tta-service?utm_test=abc&test=def" }
      it { is_expected.to redirect_to "https://tta-service/?utm_test=abc" }
    end
  end
end
