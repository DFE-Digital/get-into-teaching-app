require "rails_helper"

describe WaysToTrainController do
  describe "#show" do
    include_context "always render testing page"

    subject do
      get "/ways-to-train"

      response
    end

    context "viewing ways-to-train" do
      it { is_expected.to have_http_status :success }
    end
  end
end
