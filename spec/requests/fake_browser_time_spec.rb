require "rails_helper"

describe "Fake browser time", type: :request do
  subject { response.body }

  before do
    allow(Rails).to receive(:env) { environment.inquiry }
    get path
  end

  context "when running in the test environment" do
    let(:environment) { "test" }

    context "when the path has fake_browser_time in the query string" do
      let(:path) { root_path(fake_browser_time: Time.zone.now.to_i) }

      it { is_expected.to include("fake_browser_time") }
    end

    context "when the path does not have fake_browser_time in the query string" do
      let(:path) { root_path }

      it { is_expected.not_to include("fake_browser_time") }
    end
  end

  context "when running in the production environment" do
    let(:environment) { "production" }

    context "when the path has fake_browser_time in the query string" do
      let(:path) { root_path(fake_browser_time: Time.zone.now.to_i) }

      it { is_expected.not_to include("fake_browser_time") }
    end
  end
end
