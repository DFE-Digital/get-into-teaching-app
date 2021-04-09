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
        /<picture><source srcset=\"\" type="image\/svg\+xml" data-srcset=".*\.svg"><\/source><img alt="Department for education" src=\"\" width=\"92\" height=\"54\" data-src=".*\.svg" class=" lazyload"><noscript>.*<\/noscript><\/picture>/,
      )
    end
  end

  context "when not running in preprod" do
    let(:preprod) { false }

    it { is_expected.to_not include("<picture>") }
  end
end
