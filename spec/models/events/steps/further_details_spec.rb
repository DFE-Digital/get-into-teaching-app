require "rails_helper"

describe Events::Steps::FurtherDetails do
  include_context "wizard step"

  it_behaves_like "a wizard step"

  context "attributes" do
    it { is_expected.to respond_to :event_id }
    it { is_expected.to respond_to :privacy_policy }
    it { is_expected.to respond_to :future_events }
    it { is_expected.to respond_to :address_postcode }
  end

  context "validations" do
    it { is_expected.to allow_value("abc123").for :event_id }
    it { is_expected.not_to allow_value("").for :event_id }

    it { is_expected.to allow_value("1").for :privacy_policy }
    it { is_expected.not_to allow_value("0").for :privacy_policy }
    it { is_expected.not_to allow_value("").for :privacy_policy }

    it { is_expected.to allow_value("1").for :future_events }
    it { is_expected.to allow_value("0").for :future_events }
    it { is_expected.not_to allow_value("").for :future_events }

    it { is_expected.to allow_value("TE571NG").for :address_postcode }
    it { is_expected.to allow_value("TE57 1NG").for :address_postcode }
    it { is_expected.to allow_value(" TE57 1NG ").for :address_postcode }
    it { is_expected.to allow_value("").for :address_postcode }
    it { is_expected.not_to allow_value("unknown").for :address_postcode }
  end

  context "data cleaning" do
    it "cleans the postcode" do
      subject.address_postcode = "  TE57 1NG "
      subject.valid?
      expect(subject.address_postcode).to eq("TE57 1NG")
      subject.address_postcode = "  "
      subject.valid?
      expect(subject.address_postcode).to be_nil
    end
  end

  describe "#save" do
    context "when invalid" do
      before do
        subject.privacy_policy = nil
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
        subject.event_id = "abc123"
        subject.privacy_policy = true
        subject.future_events = true

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
