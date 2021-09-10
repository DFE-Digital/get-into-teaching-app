require "rails_helper"

describe "Zendesk chat snippet", type: :request do
  subject { response.body }

  before do
    allow(Rails.application.config.x).to receive(:zendesk_chat) { enabled }
    get(root_path)
  end

  context "when disabled" do
    let(:enabled) { false }

    it { is_expected.not_to include("https://static.zdassets.com/ekr/snippet.js") }
  end

  context "when enabled" do
    let(:enabled) { true }

    it { is_expected.to include("https://static.zdassets.com/ekr/snippet.js") }
  end
end
