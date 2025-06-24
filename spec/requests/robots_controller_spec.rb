require "rails_helper"

describe RobotsController, type: :request do
  subject { response.body }

  before { get("/robots.txt") }

  it do
    is_expected.to eq(
      <<~ROBOTS,
        User-agent: *
        Allow: /
        Disallow: /packs$
        Disallow: /packs/*
        Sitemap: https://getintoteaching.education.gov.uk/sitemap.xml

        # this allows shares on Facebook to include an image
        User-agent: facebookexternalhit
        Allow: /
      ROBOTS
    )
  end
end
