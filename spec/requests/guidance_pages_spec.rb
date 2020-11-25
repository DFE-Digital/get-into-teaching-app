require "rails_helper"

describe GuidanceController do
  describe "#show" do
    include_context "always render testing page"

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
