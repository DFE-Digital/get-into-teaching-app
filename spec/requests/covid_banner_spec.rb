require "rails_helper"

describe "Covid banner", type: :request do
  subject { response.body }

  let(:covid_banner_enabled) { true }

  before do
    allow(Rails.application.config.x).to receive(:covid_banner) { covid_banner_enabled }
    get root_path
  end

  it { is_expected.to include("data-controller=\"banner\"") }

  context "when feature switched off" do
    let(:covid_banner_enabled) { false }

    it { is_expected.not_to include("data-controller=\"banner\"") }
  end
end
