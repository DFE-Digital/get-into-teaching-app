require "rails_helper"

describe "GET /sessions/form_authenticity_token" do
  before { get sessions_crsf_token_path }
  subject { response }

  it { is_expected.to have_http_status(:success) }

  context "within the response body" do
    subject { response.body }

    it { is_expected.to match(/{"token":".{88}"}/) }
  end
end
