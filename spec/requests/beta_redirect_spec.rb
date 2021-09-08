require "rails_helper"

describe "Redirecting beta-getintoteaching.education.gov.uk to getintoteaching.education.gov.uk", type: :request do
  before { allow(Rails.configuration.x).to receive(:enable_beta_redirects).and_return(true) }

  before { host!("beta-getintoteaching.education.gov.uk") }

  it "redirects content pages" do
    get "/a-very-nice-page?something=value"

    expect(response).to redirect_to("http://getintoteaching.education.gov.uk/a-very-nice-page?something=value")
  end
end
