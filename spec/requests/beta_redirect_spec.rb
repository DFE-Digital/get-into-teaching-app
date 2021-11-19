require "rails_helper"

describe "Redirecting beta-getintoteaching.education.gov.uk to getintoteaching.education.gov.uk", type: :request do
  before do
    host!("beta-getintoteaching.education.gov.uk")
  end

  it "redirects content pages" do
    get "/a-very-nice-page?something=value"

    expect(response).to redirect_to("http://getintoteaching.education.gov.uk/a-very-nice-page?something=value")
  end
end
