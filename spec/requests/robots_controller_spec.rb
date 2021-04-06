require "rails_helper"

describe RobotsController do
  before { get("/robots.txt") }
  subject { response.body }

  it { is_expected.to match("User-agent") }
  it { is_expected.to match("SemrushBot-SA") }
  it { is_expected.to match("AhrefsSiteAudit") }
end
