require "rails_helper"

describe "Redirecting beta-getintoteaching.education.gov.uk to getintoteaching.education.gov.uk", type: "routing" do
  before { allow(Rails.configuration.x).to receive(:enable_beta_redirects).and_return(true) }

  specify "redirects content pages" do
    expect(get: "https://beta-getintoteaching.education.gov.uk/a-very-nice-page").to route_to(
      controller: "pages",
      action: "show",
      page: "a-very-nice-page",
    )
  end

  specify "redirects pages with query strings" do
    expect(get: "https://beta-getintoteaching.education.gov.uk/a-very-nice-page?test=value").to route_to(
      controller: "pages",
      action: "show",
      page: "a-very-nice-page",
      test: "value",
    )
  end
end
