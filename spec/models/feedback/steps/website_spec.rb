require "rails_helper"

describe Feedback::Steps::Website do
  include_context "with wizard step"
  let(:wizard) { Feedback::Wizard.new(wizardstore, described_class.key) }

  it_behaves_like "a with wizard step"

  it { is_expected.to be_can_proceed }

  describe "#skipped?" do
    it "is skipped when feedback about the website is not selected" do
      wizardstore["topic"] = "Give feedback about signing up for an adviser"
      is_expected.to be_skipped
    end

    it "is not skipped when feedback about the website is selected" do
      wizardstore["topic"] = "Give feedback about the website"
      is_expected.not_to be_skipped
    end
  end
end
