require "rails_helper"

describe HealthchecksController do
  before do
    allow_any_instance_of(Healthcheck).to receive(:test_api).and_return true
  end

  describe "#show" do
    before { get healthcheck_path }
    it { expect(response).to have_http_status(:success) }
  end
end
