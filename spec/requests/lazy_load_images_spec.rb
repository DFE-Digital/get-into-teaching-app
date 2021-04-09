require "rails_helper"

describe "Lazy Load Images" do
  before do
    allow(Rails.env).to receive(:preprod?) { preprod }
    get root_path
  end
  subject { response.body }

  context "when running in preprod" do
    let(:preprod) { true }

    it { is_expected.to include("data-src") }
    it { is_expected.to include("lazyload") }
  end

  context "when not running in preprod" do
    let(:preprod) { false }

    it { is_expected.to_not include("data-src") }
    it { is_expected.to_not include("lazyload") }
  end
end
