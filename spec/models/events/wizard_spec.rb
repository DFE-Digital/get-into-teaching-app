require "rails_helper"

describe Events::Wizard do
  let(:uuid) { SecureRandom.uuid }
  let(:store) do
    { uuid => {
      "event_id" => "abc123",
      "email" => "email@address.com",
      "first_name" => "Joe",
      "last_name" => "Joseph",
    } }
  end
  let(:wizardstore) { Wizard::Store.new store[uuid], {} }

  subject { described_class.new wizardstore, "personalised_updates" }

  describe ".steps" do
    subject { described_class.steps }

    it do
      is_expected.to eql [
        Events::Steps::PersonalDetails,
        ::Wizard::Steps::Authenticate,
        Events::Steps::ContactDetails,
        Events::Steps::FurtherDetails,
        Events::Steps::PersonalisedUpdates,
      ]
    end
  end

  describe "#complete!" do
    let(:request) do
      GetIntoTeachingApiClient::TeachingEventAddAttendee.new(
        { eventId: "abc123", email: "email@address.com", firstName: "Joe", lastName: "Joseph" },
      )
    end

    before do
      allow(subject).to receive(:valid?) { true }
      allow_any_instance_of(GetIntoTeachingApiClient::TeachingEventsApi).to \
        receive(:add_teaching_event_attendee).with(request).once
      allow(Rails.logger).to receive(:info)
      subject.complete!
    end

    it { is_expected.to have_received(:valid?) }
    it { expect(store[uuid]).to eql({}) }

    it "logs the request model (filtering sensitive attributes)" do
      filtered_json = { "eventId" => "abc123", "email" => "[FILTERED]", "firstName" => "[FILTERED]", "lastName" => "[FILTERED]" }.to_json
      expect(Rails.logger).to have_received(:info).with("Events::Wizard#add_attendee_to_event: #{filtered_json}")
    end
  end

  describe "#exchange_access_token" do
    let(:totp) { "123456" }
    let(:request) { GetIntoTeachingApiClient::ExistingCandidateRequest.new }
    let(:response) { GetIntoTeachingApiClient::TeachingEventAddAttendee.new(candidateId: "123", addressTelephone: "12345") }

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
end
