require "rails_helper"

describe Callbacks::Wizard do
  subject { described_class.new wizardstore, "talking_points" }

  let(:uuid) { SecureRandom.uuid }
  let(:store) do
    {
      uuid => {
        "email" => "email@address.com",
        "first_name" => "John",
        "last_name" => "Doe",
        "talking_points" => "Something",
        "creation_channel_source_id" => 222_750_003,
        "creation_channel_service_id" => 222_750_005,
        "creation_channel_activity_id" => nil,
      },
    }
  end
  let(:wizardstore) { GITWizard::Store.new store[uuid], {} }

  describe ".steps" do
    subject { described_class.steps }

    it do
      is_expected.to eql [
        Callbacks::Steps::PersonalDetails,
        Callbacks::Steps::MatchbackFailed,
        ::GITWizard::Steps::Authenticate,
        Callbacks::Steps::Callback,
        Callbacks::Steps::TalkingPoints,
      ]
    end
  end

  describe "#matchback_attributes" do
    it do
      expect(subject.matchback_attributes).to match_array(%i[candidate_id qualification_id])
    end
  end

  describe "#complete!" do
    let(:request) do
      GetIntoTeachingApiClient::GetIntoTeachingCallback.new(
        email: "email@address.com",
        first_name: "John",
        last_name: "Doe",
        talking_points: "Something",
        accepted_policy_id: "123",
        creation_channel_source_id: 222_750_003,
        creation_channel_service_id: 222_750_005,
        creation_channel_activity_id: nil,
      )
    end

    before do
      allow(subject).to receive_messages(valid?: true, can_proceed?: true)
      allow_any_instance_of(GetIntoTeachingApiClient::GetIntoTeachingApi).to \
        receive(:book_get_into_teaching_callback).with(request)
      allow(Rails.logger).to receive(:info)
      subject.complete!
    end

    it { is_expected.to have_received(:valid?) }
    it { expect(store[uuid]).to eql({}) }

    it "logs the request model (filtering sensitive attributes)" do
      filtered_json = {
        "candidateId" => nil,
        "acceptedPolicyId" => "123",
        "email" => "[FILTERED]",
        "firstName" => "[FILTERED]",
        "lastName" => "[FILTERED]",
        "talkingPoints" => "Something",
        "creationChannelSourceId" => 222_750_003,
        "creationChannelServiceId" => 222_750_005,
        "creationChannelActivityId" => nil,
      }.to_json

      expect(Rails.logger).to have_received(:info).with("Callbacks::Wizard#book_get_into_teaching_callback: #{filtered_json}")
    end
  end

  describe "#exchange_access_token" do
    let(:totp) { "123456" }
    let(:request) { GetIntoTeachingApiClient::ExistingCandidateRequest.new }
    let(:response) { GetIntoTeachingApiClient::GetIntoTeachingCallback.new(candidate_id: "123", email: "12345") }

    before do
      allow_any_instance_of(GetIntoTeachingApiClient::GetIntoTeachingApi).to \
        receive(:exchange_access_token_for_get_into_teaching_callback)
        .with(totp, request) { response }
    end

    it "calls exchange_access_token_for_get_into_teaching_callback" do
      expect(subject.exchange_access_token(totp, request)).to eq(response)
    end

    it "logs the response model (filtering sensitive attributes)" do
      filtered_json = { "candidateId" => "123", "email" => "[FILTERED]" }.to_json
      expect(Rails.logger).to receive(:info).with("Callbacks::Wizard#exchange_access_token: #{filtered_json}")
      subject.exchange_access_token(totp, request)
    end
  end
end
