require "rails_helper"

RSpec.describe "Basic auth", type: :request do
  let(:username) { "username" }
  let(:password) { "password" }

  before do
    allow_basic_auth_users([{ username: username, password: password }])
  end

  context "when basic auth is disabled" do
    before { allow(Rails.application.config.x).to receive(:basic_auth) { "0" } }

    it "is not enforced" do
      get root_path
      expect(response).to be_successful
    end
  end

  context "when basic auth is enabled" do
    before { allow(Rails.application.config.x).to receive(:basic_auth) { "1" } }

    it "returns unauthorized if credentials do not match" do
      get root_path, params: {}, headers: basic_auth_headers(username, "wrong-password")
      expect(response).to be_unauthorized
    end

    it "returns success and sets a user session if credentials match" do
      get root_path, params: {}, headers: basic_auth_headers(username, password)
      expect(response).to be_successful
      expect(request.session[:user]).to eq(true)
    end
  end
end
