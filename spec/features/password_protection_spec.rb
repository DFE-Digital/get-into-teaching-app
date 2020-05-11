require "rails_helper"

RSpec.feature "Password protection", type: :feature do
  before do
    allow(ENV).to receive(:[]).and_call_original
    allow(ENV).to receive(:[]).with("HTTPAUTH_USERNAME") { username }
    allow(ENV).to receive(:[]).with("HTTPAUTH_PASSWORD") { password }
  end

  subject { visit root_path; page }

  context "when password protection is not set" do
    let(:username) { "" }
    let(:password) { "" }

    it { is_expected.to have_http_status :success }
  end

  context "when password protection set" do
    let(:username) { "username" }
    let(:password) { "password" }

    it { is_expected.to have_http_status :unauthorized }
  end
end
