require "rails_helper"

describe "VWO", type: :request do
  let(:config_path) { Rails.root.join("config/vwo.yml") }
  let(:yaml) do
    <<-YAML
    paths:
      - /vwo-test
    YAML
  end

  before do
    ApplicationController.class_variable_set :@@vwo_config, nil

    allow(ENV).to receive(:[]).and_call_original
    allow(ENV).to receive(:[]).with("VWO_ID").and_return("12345")

    allow(File).to receive(:read).and_call_original
    expect(File).to receive(:read).with(config_path) { yaml }
  end

  subject { response.body }

  context "when the path exists in the VWO config" do
    before { get "/vwo-test" }

    it { is_expected.to include("vwo_code") }
  end

  context "when the path does not exists in the VWO config" do
    before { get "/no-vwo-test" }

    it { is_expected.not_to match("vwo_code") }
  end
end
