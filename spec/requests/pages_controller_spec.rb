require "rails_helper"

describe PagesController, type: :request do
  describe "#show" do
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

  describe "#filtered_page_template" do
    subject { controller.send :filtered_page_template }

    let(:controller) { described_class.new }
    let(:params) { { page: template } }

    before { allow(controller).to receive(:params).and_return params }

    context "with valid page template" do
      let(:template) { "hello" }

      it { is_expected.to eql "hello" }
    end

    context "with nested template" do
      let(:template) { "hello/world" }

      it { is_expected.to eql "hello/world" }
    end

    context "with invalid page template" do
      let(:template) { "invalid!" }

      it { expect { subject }.to raise_exception described_class::InvalidTemplateName }
    end

    context "with param linking to parent page" do
      let(:template) { "../../secrets.txt" }

      it { expect { subject }.to raise_exception described_class::InvalidTemplateName }
    end

    context "with file extension" do
      let(:template) { "stories/how-i-got-into-teaching.html" }

      it { is_expected.to eql "stories/how-i-got-into-teaching.html" }
    end

    context "with numbers in name" do
      let(:template) { "stories/my-top-10" }

      it { is_expected.to eql "stories/my-top-10" }
    end

    context "with custom page value" do
      subject { controller.send :filtered_page_template, :story }

      let(:params) { { story: "hello" } }

      it { is_expected.to eql "hello" }
    end
  end
end
