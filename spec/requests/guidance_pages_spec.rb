require "rails_helper"

describe GuidanceController do
  describe "#show" do
    let(:template) { "testing/markdown_test" }
    before do
      allow_any_instance_of(described_class).to \
        receive(:guidance_template).and_return template
    end

    subject do
      get "/guidance/become-a-teacher-in-england"
      response
    end

    context "for known page" do
      it { is_expected.to have_http_status :success }
    end

    context "for unknown page" do
      let(:template) { "testing/other-page" }

      it { is_expected.to have_http_status :not_found }
      it { is_expected.to have_attributes body: %r{Page not found} }
    end
  end
end
