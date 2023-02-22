require "rails_helper"

describe MailingList::Steps::AlreadyQualified do
  include_context "with wizard step"
  let(:wizard) { MailingList::Wizard.new(wizardstore, described_class.key) }

  it_behaves_like "a with wizard step"

  it { is_expected.not_to be_can_proceed }

  describe "#skipped?" do
    it "is skipped when not yet qualified to teach" do
      wizardstore["qualified_to_teach"] = false
      is_expected.to be_skipped
    end

    it "is not skipped when already qualified to teach" do
      wizardstore["qualified_to_teach"] = true
      is_expected.not_to be_skipped
    end
  end
end
