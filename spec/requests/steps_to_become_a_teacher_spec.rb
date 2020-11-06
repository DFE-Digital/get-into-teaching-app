require "rails_helper"

describe StepsToBecomeATeacherController do
  describe "#show" do
    let(:template) { "testing/markdown_test" }

    subject do
      get "/steps-to-become-a-teacher"
      response
    end

    context "viewing steps-to-become-a-teacher" do
      it { is_expected.to have_http_status :success }

      it "should be the correct template" do
        expect(subject.body).to match("Steps to become a teacher")
      end
    end
  end
end
