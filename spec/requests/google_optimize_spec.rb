require "rails_helper"

describe "Google Optimize", type: :request do
  subject { response.body }

  let(:config_path) { Rails.root.join("config/google_optimize.yml") }
  let(:yaml) do
    <<-YAML
    paths:
      - /google-optimize-test
    YAML
  end

  before do
    ApplicationHelper.class_variable_set :@@google_optimize_config, nil

    allow(ENV).to receive(:[]).and_call_original
    allow(ENV).to receive(:[]).with("GOOGLE_OPTIMIZE_ID").and_return("12345")

    allow(File).to receive(:read).and_call_original
    allow(File).to receive(:read).with(config_path) { yaml }
  end

  after do
    ApplicationHelper.class_variable_set :@@google_optimize_config, nil
  end

  context "when the path exists in the Google Optimize config" do
    before { get "/google-optimize-test" }

    it { is_expected.to include("https://www.googleoptimize.com/optimize.js") }
  end

  context "when the path does not exists in the Google Optimize config" do
    before { get "/no-google-optimize-test" }

    it { is_expected.not_to include("https://www.googleoptimize.com/optimize.js") }
  end
end
