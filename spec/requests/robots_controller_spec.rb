require "rails_helper"

describe RobotsController, type: :request do
  before { get("/robots.txt") }

  subject { response.body }

  it do
    is_expected.to eq(
      <<~ROBOTS,
        User-agent: *
        Allow: /

        Sitemap: https://getintoteaching.education.gov.uk/sitemap.xml
      ROBOTS
    )
  end
end
