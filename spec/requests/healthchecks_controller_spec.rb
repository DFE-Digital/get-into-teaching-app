require "rails_helper"

describe HealthchecksController do
  describe "#show" do
    before { get healthcheck_path }
    it { expect(response).to have_http_status(:success) }
  end
end
