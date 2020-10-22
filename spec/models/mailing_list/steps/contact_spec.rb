require "rails_helper"

describe MailingList::Steps::Contact do
  include_context "wizard step", MailingList::Wizard
  it_behaves_like "a wizard step"

  it { is_expected.to respond_to :telephone }
  it { is_expected.to respond_to :accept_privacy_policy }
  it { is_expected.to respond_to :accepted_policy_id }

  context "validations" do
    subject { instance.tap(&:valid?).errors.messages }
    it { is_expected.to include(:accept_privacy_policy) }
  end

  context "telephone" do
    it { is_expected.to allow_value(nil).for :telephone }
    it { is_expected.to allow_value("").for :telephone }
    it { is_expected.to allow_value("01234567890").for :telephone }
    it { is_expected.to allow_value(" 07123 45789 ").for :telephone }
    it { is_expected.not_to allow_value("1234").for :telephone }
  end

  context "data cleaning" do
    it "cleans the telephone" do
      subject.telephone = "  01234567890 "
      subject.valid?
      expect(subject.telephone).to eq("01234567890")
      subject.telephone = "  "
      subject.valid?
      expect(subject.telephone).to be_nil
    end
  end

  context "accept_privacy_policy" do
    it { is_expected.to validate_acceptance_of :accept_privacy_policy }
  end
end
