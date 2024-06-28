require "rails_helper"

RSpec.describe "Invalid Authenticity Token", type: :request do
  before do
    ActionController::Base.allow_forgery_protection = true
    allow(Sentry).to receive(:capture_exception)
  end

  after do
    ActionController::Base.allow_forgery_protection = false
  end

  describe "with an invalid authenticity token" do
    it "redirects to the session_expired page" do
      identity_params = { email: "email@address.com", first_name: "first", last_name: "last" }
      params = { "authenticity_token" => "expired", identity: identity_params }
      put teacher_training_adviser_step_path(:identity), params: params
      expect(response).to redirect_to session_expired_path
      expect(Sentry).to have_received(:capture_exception)
    end
  end
end
