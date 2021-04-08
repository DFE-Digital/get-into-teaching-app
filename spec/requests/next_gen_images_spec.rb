require "rails_helper"

describe "Next Gen Images" do
  before do
    allow(Rails.env).to receive(:preprod?) { preprod }
    allow(File).to receive(:exist?).and_call_original
    allow(File).to receive(:exist?).with(/.*\.svg/) { true }
    get root_path
  end
  subject { response.body }

  context "when running in preprod" do
    let(:preprod) { true }

    it do
      is_expected.to match(
        /<picture><img alt="Department for education" src=".*\.svg"><source srcset=".*\.svg" type="image\/svg\+xml"><\/source><\/picture>/,
      )
    end
  end

  context "when not running in preprod" do
    let(:preprod) { false }

    it { is_expected.to_not include("<picture>") }
  end
end
