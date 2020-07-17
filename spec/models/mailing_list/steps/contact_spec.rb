require "rails_helper"

describe MailingList::Steps::Contact do
  include_context "wizard step"
  it_behaves_like "a wizard step"

  it { is_expected.to respond_to :telephone }
  it { is_expected.to respond_to :callback_information }
  it { is_expected.to respond_to :accept_privacy_policy }

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

  context "callback_information" do
    it { is_expected.to allow_value(nil).for :callback_information }
    it { is_expected.to allow_value("").for :callback_information }
    it { is_expected.to allow_value("Lorem ipsum").for :callback_information }

    context "with phone number present" do
      let(:attributes) { { telephone: "0123456890" } }
      it { is_expected.not_to allow_value(nil).for :callback_information }
      it { is_expected.not_to allow_value("").for :callback_information }
      it { is_expected.to allow_value("Lorem ipsum").for :callback_information }
    end

    context "with too many words" do
      it { is_expected.to allow_value("word " * 200).for :callback_information }
      it { is_expected.not_to allow_value("word " * 201).for :callback_information }
    end
  end

  context "accept_privacy_policy" do
    it { is_expected.to validate_acceptance_of :accept_privacy_policy }
  end
end
