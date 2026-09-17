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

    context "with a noindexed page" do
      subject { response }

      before { get "/landing/advisers" }

      it { is_expected.not_to be_indexed }
    end

    context "with mailing list landing page" do
      subject { response }

      before { get "/landing/mailing-list" }

      it { is_expected.to have_http_status :success }
      it { is_expected.to have_attributes body: /Get the latest information sent straight to your inbox/i }
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

    context "with a page that has a variant active for today" do
      subject { response }

      before { travel_to(Time.zone.local(2026, 10, 15)) { get "/testing/variant-page" } }

      it { is_expected.to have_http_status :success }
      it { is_expected.to have_attributes body: /Variant v1 body/ }
    end

    context "with a page whose variant window is not current" do
      subject { response }

      before { travel_to(Time.zone.local(2026, 9, 15)) { get "/testing/variant-page" } }

      it { is_expected.to have_http_status :success }
      it { is_expected.to have_attributes body: /Base page body/ }
    end

    context "with a variant path requested directly" do
      subject { response }

      before { get "/testing/variant-page+v1" }

      it { is_expected.to have_http_status :not_found }
    end

    context "with a ?version override outside the variant window" do
      subject { response }

      before { travel_to(Time.zone.local(2027, 1, 1)) { get "/testing/variant-page?version=v1" } }

      it { is_expected.to have_http_status :success }
      it { is_expected.to have_attributes body: /Variant v1 body/ }
    end
  end

  describe "#preview_version" do
    subject { controller.send(:preview_version) }

    let(:controller) { described_class.new }

    before do
      allow(controller).to receive(:params).and_return(ActionController::Parameters.new(version: version))
    end

    context "when in a local environment (development or test)" do
      context "with a valid version" do
        let(:version) { "v1" }

        it { is_expected.to eq "v1" }
      end

      context "with a version containing invalid characters" do
        let(:version) { "../secret" }

        it { is_expected.to be_nil }
      end
    end

    context "when in production" do
      let(:version) { "v1" }

      before { allow(Rails).to receive(:env).and_return(ActiveSupport::StringInquirer.new("production")) }

      it { is_expected.to be_nil }
    end
  end

  describe "#filtered_page_template" do
    subject { controller.send(:filtered_page_template, template) }

    let(:controller) { described_class.new }

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
  end
end
