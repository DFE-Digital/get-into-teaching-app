require "rails_helper"

describe MailingList::Steps::AlreadySubscribed do
  include_context "with wizard step"
  it_behaves_like "a with wizard step"

  it { is_expected.not_to be_can_proceed }

  describe "#skipped?" do
    it "returns true if already_subscribed_to_mailing_list is false/nil/undefined" do
      expect(subject).to be_skipped
      wizardstore["already_subscribed_to_mailing_list"] = nil
      expect(subject).to be_skipped
      wizardstore["already_subscribed_to_mailing_list"] = false
      expect(subject).to be_skipped
    end

    it "returns true if already_subscribed_to_teacher_training_adviser is false/true/nil/undefined" do
      expect(subject).to be_skipped
      wizardstore["already_subscribed_to_teacher_training_adviser"] = nil
      expect(subject).to be_skipped
      wizardstore["already_subscribed_to_teacher_training_adviser"] = false
      expect(subject).to be_skipped
      wizardstore["already_subscribed_to_teacher_training_adviser"] = true
      expect(subject).to be_skipped
    end

    it "returns false if already_subscribed_to_mailing_list is true" do
      wizardstore["already_subscribed_to_mailing_list"] = true
      expect(subject).not_to be_skipped
    end
  end
end
