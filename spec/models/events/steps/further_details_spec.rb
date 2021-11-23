require "rails_helper"

describe Events::Steps::FurtherDetails do
  include_context "with wizard step"

  it_behaves_like "a with wizard step"

  describe "attributes" do
    it { is_expected.to respond_to :event_id }
    it { is_expected.to respond_to :privacy_policy }
    it { is_expected.to respond_to :subscribe_to_mailing_list }
    it { is_expected.to respond_to :accepted_policy_id }
  end

  describe "validations" do
    it { is_expected.to allow_value("abc123").for :event_id }
    it { is_expected.not_to allow_value("").for :event_id }

    describe "for privacy_policy" do
      it { is_expected.to allow_value("1").for :privacy_policy }
      it { is_expected.not_to allow_value("0").for :privacy_policy }
      it { is_expected.not_to allow_value("").for :privacy_policy }
    end

    describe "for subscribe_to_mailing_list" do
      it { is_expected.to allow_values("1").for :subscribe_to_mailing_list }
      it { is_expected.to allow_value("0").for :subscribe_to_mailing_list }
      it { is_expected.not_to allow_value("").for :subscribe_to_mailing_list }
    end

    describe "#already_subscribed_to_mailing_list" do
      let(:backingstore) { { "already_subscribed_to_mailing_list" => true } }

      it { is_expected.to allow_value("1").for :subscribe_to_mailing_list }
      it { is_expected.to allow_value("0").for :subscribe_to_mailing_list }
      it { is_expected.to allow_value("").for :subscribe_to_mailing_list }
    end

    describe "#already_subscribed_to_teacher_training_adviser" do
      let(:backingstore) { { "already_subscribed_to_teacher_training_adviser" => true } }

      it { is_expected.to allow_value("1").for :subscribe_to_mailing_list }
      it { is_expected.to allow_value("0").for :subscribe_to_mailing_list }
      it { is_expected.to allow_value("").for :subscribe_to_mailing_list }
    end
  end

  describe "#save" do
    context "when invalid" do
      before do
        subject.privacy_policy = nil
      end

      it "does not update the store" do
        expect_any_instance_of(GetIntoTeachingApiClient::PrivacyPoliciesApi).not_to \
          receive(:get_latest_privacy_policy)

        expect(subject).not_to be_valid
        subject.save
        expect(wizardstore["subscribe_to_mailing_list"]).to be_nil
      end
    end

    context "when valid" do
      let(:response) { GetIntoTeachingApiClient::PrivacyPolicy.new({ id: 123 }) }

      before do
        subject.event_id = "abc123"
        subject.privacy_policy = true

        allow_any_instance_of(GetIntoTeachingApiClient::PrivacyPoliciesApi).to \
          receive(:get_latest_privacy_policy).and_return(response)
      end

      it "updates the store if the candidate subscribes" do
        subject.subscribe_to_mailing_list = true
        expect(subject).to be_valid
        subject.save
        expect(wizardstore["subscribe_to_mailing_list"]).to be_truthy
      end

      it "updates the store if the candidate does not subscribe" do
        subject.subscribe_to_mailing_list = false
        expect(subject).to be_valid
        subject.save
        expect(wizardstore["subscribe_to_mailing_list"]).to be_falsy
      end
    end
  end
end
