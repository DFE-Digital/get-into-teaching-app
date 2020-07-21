require "rails_helper"

describe MailingList::Steps::Contact do
  include_context "wizard step"
  it_behaves_like "a wizard step"

  it { is_expected.to respond_to :telephone }
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
        expect(wizardstore["subscribe_to_events"]).to be_nil
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
        expect(wizardstore["subscribe_to_events"]).to be_truthy
      end
    end
  end
end
