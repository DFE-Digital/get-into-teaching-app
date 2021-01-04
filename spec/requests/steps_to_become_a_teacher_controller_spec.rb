require "rails_helper"

describe StepsToBecomeATeacherController do
  describe "#show" do
    include_context "always render testing page"

    subject do
      get "/steps-to-become-a-teacher"

      response
    end

    context "viewing steps-to-become-a-teacher" do
      it { is_expected.to have_http_status :success }
    end
  end
end
