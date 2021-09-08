require "rails_helper"

describe PagesController do
  describe "#show" do
    context "without caching enabled" do
      it "does not have cache headers" do
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

      it "utilises cached version" do
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
      before { get "/testing/unknown" }

      subject { response }

      it { is_expected.to have_http_status :not_found }
      it { is_expected.to have_attributes body: %r{Page not found} }
    end

    context "with cookies page" do
      before { get "/cookies" }

      subject { response }

      it { is_expected.to have_http_status(:success) }
    end

    context "with invalid page" do
      before do
        expect_any_instance_of(described_class).to \
          receive(:render).with(status: :not_found, body: nil).and_call_original

        get "/../../secrets.txt"
      end

      subject { response }

      it { is_expected.to have_http_status :not_found }
      it { is_expected.to have_attributes body: "" }
    end
  end

  describe "redirect to TTA site" do
    include_context "with stubbed env vars", "TTA_SERVICE_URL" => "https://tta-service/"
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
