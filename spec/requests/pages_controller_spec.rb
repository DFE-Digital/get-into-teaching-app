require "rails_helper"

describe PagesController, type: :request do
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
      subject { response }

      before { get "/testing/unknown" }

      it { is_expected.to have_http_status :not_found }
      it { is_expected.to have_attributes body: %r{Page not found} }
    end

    context "with cookies page" do
      subject { response }

      before { get "/cookies" }

      it { is_expected.to have_http_status(:success) }
    end

    context "with invalid page" do
      subject { response }

      before do
        allow_any_instance_of(described_class).to \
          receive(:render).with(status: :not_found, body: nil).and_call_original

        get "/../../secrets.txt"
      end

      it { is_expected.to have_http_status :not_found }
      it { is_expected.to have_attributes body: "" }
    end
  end

  describe "persisting welcome guide data in the session" do
    subject { response }

    let(:params) do
      {
        "preferred_teaching_subject_id" => "802655a1-2afa-e811-a981-000d3a276620",
        "degree_status_id" => "222_750_003",
        "a_key_that_shouldnt_be_accepted" => "abc123",
      }
    end

    let(:joined_params) do
      params.map { |k, v| "#{k}=#{v}" }.join("&")
    end

    before { get %(/welcome?#{joined_params}) }

    specify "the params are saved to the session" do
      expect(session["welcome_guide"]).to eql(params.except("a_key_that_shouldnt_be_accepted"))
    end
  end

  describe "redirect to TTA site" do
    include_context "with stubbed env vars", "TTA_SERVICE_URL" => "https://tta-service/"
    subject { response }

    context "with /tta-service url" do
      before { get "/tta-service" }

      it { is_expected.to redirect_to "https://tta-service/" }
      it { expect(response).to have_http_status(:moved_permanently) }
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
