require "rails_helper"
require "page_speed_score"

describe "Page Speed Task", type: :request do
  let(:run_pagespeed_path) { "/pagespeed/run" }

  before { allow(Rails.env).to receive(:pagespeed?) { pagespeed_env } }

  context "when not in the pagespeed environment" do
    let(:pagespeed_env) { false }

    it "returns 404" do
      expect { post run_pagespeed_path }.to raise_error(ActionController::RoutingError)
    end
  end

  context "when in the pagespeed environment" do
    let(:pagespeed_env) { true }

    before do
      expect_any_instance_of(PageSpeedScore).to receive(:fetch)
    end

    it "returns 204" do
      post run_pagespeed_path
      expect(response).to have_http_status(:no_content)
    end
  end
end
