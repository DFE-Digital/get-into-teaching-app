require "rails_helper"

describe MailingList::Steps::PrivacyPolicy do
  include_context "wizard step"
  it_behaves_like "a wizard step"

  it { is_expected.to respond_to :accept_privacy_policy }
  it { is_expected.to respond_to :accepted_policy_id }

  describe "validations" do
    subject { instance.tap(&:valid?).errors.messages }

    it { is_expected.to include(:accept_privacy_policy) }
  end

  describe "#accept_privacy_policy" do
    it { is_expected.to validate_acceptance_of :accept_privacy_policy }
  end
end
