require "rails_helper"

describe Events::Wizard do
  subject { described_class.new(wizardstore, described_class.steps.last.key) }

  let(:uuid) { SecureRandom.uuid }
  let(:store) do
    { uuid => {
      "event_id" => "abc123",
      "email" => "email@address.com",
      "first_name" => "Joe",
      "last_name" => "Joseph",
      "accepted_policy_id" => "789",
      "is_walk_in" => true,
      "channel_id" => nil,
      "creation_channel_source_id" => 222_750_003,
      "creation_channel_service_id" => 222_750_006,
      "creation_channel_activity_id" => nil,
    } }
  end
  let(:wizardstore) { GITWizard::Store.new store[uuid], {} }

  describe ".steps" do
    subject { described_class.steps }

    it do
      is_expected.to eql [
        Events::Steps::PersonalDetails,
        ::GITWizard::Steps::Authenticate,
        Events::Steps::ContactDetails,
      ]
    end
  end

  describe "#matchback_attributes" do
    it do
      expect(subject.matchback_attributes).to match_array(%i[candidate_id qualification_id is_verified])
    end
  end

  describe "#complete!" do
    let(:request) do
      GetIntoTeachingApiClient::TeachingEventAddAttendee.new(
        {
          event_id: "abc123",
          email: "email@address.com",
          first_name: "Joe",
          last_name: "Joseph",
          accepted_policy_id: "789",
          is_walk_in: true,
          channel_id: nil,
          creation_channel_source_id: 222_750_003,
          creation_channel_service_id: 222_750_006,
          creation_channel_activity_id: nil,
        },
      )
    end

    let(:filtered_attributes) { "attribute1: [FILTERED], attribute2: 1234" }

    before do
      allow(subject).to receive(:valid?).and_return(true)
      allow_any_instance_of(GetIntoTeachingApiClient::TeachingEventsApi).to \
        receive(:add_teaching_event_attendee).with(request)
      allow(Rails.logger).to receive(:info)
      allow(AttributeFilter).to receive(:filtered_json).and_return(filtered_attributes)
    end

    context "with prune! spy" do
      before { allow(wizardstore).to receive(:prune!) }

      it "prunes the store, retaining certain attributes" do
        subject.complete!
        expect(wizardstore).to have_received(:prune!).with({ leave: described_class::ATTRIBUTES_TO_LEAVE }).once
      end
    end

    context "with subject.complete!" do
      before { subject.complete! }

      it { is_expected.to have_received(:valid?) }

      it do
        hashed_email = Digest::SHA256.hexdigest("email@address.com")
        expect(store[uuid]).to eql({
          "hashed_email" => hashed_email,
          "is_walk_in" => wizardstore[:is_walk_in],
        })
      end

      it "logs the request model (filtering sensitive attributes)" do
        # NB: The order of the json fields cast as a string can vary in different
        # environments leading to test flakiness if we test the exact attributes
        # filtered. (These can be tested by the AttributeFilter specs.)

        expect(AttributeFilter).to have_received(:filtered_json).with(request)
        expect(Rails.logger).to have_received(:info).with("Events::Wizard#add_attendee_to_event: #{filtered_attributes}")
      end
    end
  end

  describe "#exchange_access_token" do
    let(:totp) { "123456" }
    let(:request) { GetIntoTeachingApiClient::ExistingCandidateRequest.new }
    let(:response) { GetIntoTeachingApiClient::TeachingEventAddAttendee.new(candidate_id: "123", address_telephone: "12345") }

    before do
      allow_any_instance_of(GetIntoTeachingApiClient::TeachingEventsApi).to \
        receive(:exchange_access_token_for_teaching_event_add_attendee)
        .with(totp, request) { response }
    end

    it "calls exchange_access_token_for_teaching_event_add_attendee" do
      expect(subject.exchange_access_token(totp, request)).to eq(response)
    end

    it "logs the response model (filtering sensitive attributes)" do
      filtered_json = { "candidateId" => "123", "addressTelephone" => "[FILTERED]" }.to_json
      expect(Rails.logger).to receive(:info).with("Events::Wizard#exchange_access_token: #{filtered_json}")
      subject.exchange_access_token(totp, request)
    end
  end

  describe "#exchange_unverified_request" do
    let(:request) { GetIntoTeachingApiClient::ExistingCandidateRequest.new }
    let(:response) { GetIntoTeachingApiClient::TeachingEventAddAttendee.new(candidate_id: "123", address_telephone: "12345") }

    before do
      allow_any_instance_of(GetIntoTeachingApiClient::TeachingEventsApi).to \
        receive(:exchange_unverified_request_for_teaching_event_add_attendee)
        .with(request) { response }
    end

    context "when candidate is not a walk in" do
      before { wizardstore[:is_walk_in] = false }

      it "raises an exception" do
        expect { subject.exchange_unverified_request(request) }.to raise_error(GITWizard::ContinueUnverifiedNotSupportedError)
      end
    end

    context "when candidate is a walk in" do
      before { wizardstore[:is_walk_in] = true }

      it "calls exchange_unverified_request_for_teaching_event_add_attendee" do
        expect(subject.exchange_unverified_request(request)).to eq(response)
      end

      it "logs the response model (filtering sensitive attributes)" do
        filtered_json = { "candidateId" => "123", "addressTelephone" => "[FILTERED]" }.to_json
        expect(Rails.logger).to receive(:info).with("Events::Wizard#exchange_unverified_request: #{filtered_json}")
        subject.exchange_unverified_request(request)
      end
    end
  end
end
