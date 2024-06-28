require "rails_helper"

describe HealthchecksController, type: :request do
  before do
    allow_any_instance_of(Healthcheck).to receive(:test_api).and_return(true)
    allow_any_instance_of(Healthcheck).to receive(:test_redis).and_return(false)
    allow_any_instance_of(Healthcheck).to receive(:test_postgresql).and_return(true)
    allow_any_instance_of(Healthcheck).to receive(:content_sha).and_return("abc")
    allow_any_instance_of(Healthcheck).to receive(:app_sha).and_return("123")
    allow(Rails.logger).to receive(:info)
  end

  describe "#show" do
    before { get healthcheck_path }

    it { expect(response).to have_http_status(:success) }

    it do
      expected_healthcheck = { app_sha: "123", content_sha: "abc", api: true, redis: false, postgres: true }
      expect(Rails.logger).to have_received(:info).with("HealthCheck: #{expected_healthcheck}").once
    end
  end
end
