require "rails_helper"

describe PagesController do
  let(:template) { "testing/markdown_test" }

  before do
    allow_any_instance_of(described_class).to \
      receive(:content_template).and_return template
  end

  context "#show" do
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

        get "/test", headers: {
          "If-None-Match" => etag,
          "If-Modified-Since" => lastmod,
        }

        expect(response).to have_http_status 304
      end
    end

    context "for unknown page" do
      let(:template) { "testing/unknown" }
      before { get "/test" }
      subject { response }
      it { is_expected.to have_http_status :not_found }
      it { is_expected.to have_attributes body: %r{Page not found} }
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
