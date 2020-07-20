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

  context "data cleaning" do
    it "cleans the telephone" do
      subject.telephone = "  01234567890 "
      subject.valid?
      expect(subject.telephone).to eq("01234567890")
      subject.telephone = "  "
      subject.valid?
      expect(subject.telephone).to be_nil
    end

    it "cleans the callback information" do
      subject.callback_information = "  please call me back "
      subject.valid?
      expect(subject.callback_information).to eq("please call me back")
      subject.callback_information = "  "
      subject.valid?
      expect(subject.callback_information).to be_nil
    end
  end

  context "accept_privacy_policy" do
    it { is_expected.to validate_acceptance_of :accept_privacy_policy }
  end

  describe "#save" do
    context "when invalid" do
      before do
        subject.accept_privacy_policy = nil
        expect_any_instance_of(GetIntoTeachingApiClient::PrivacyPoliciesApi).to_not \
          receive(:get_latest_privacy_policy)
      end

      it "does not update the store" do
        expect(subject).to_not be_valid
        subject.save
        expect(wizardstore["accepted_policy_id"]).to be_nil
        expect(wizardstore["subscribe_to_mailing_list"]).to be_nil
      end
    end

    context "when valid" do
      let(:response) { GetIntoTeachingApiClient::PrivacyPolicy.new({ id: 123 }) }

      before do
        subject.accept_privacy_policy = true

        allow_any_instance_of(GetIntoTeachingApiClient::PrivacyPoliciesApi).to \
          receive(:get_latest_privacy_policy).and_return(response)
      end

      it "updates the store" do
        expect(subject).to be_valid
        subject.save
        expect(wizardstore["accepted_policy_id"]).to be(response.id)
        expect(wizardstore["subscribe_to_mailing_list"]).to be_truthy
      end
    end
  end
end
