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
  let(:wizardstore) { Wizard::Store.new store[uuid] }
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
      expect_any_instance_of(GetIntoTeachingApiClient::TeachingEventsApi).to \
        receive(:add_teaching_event_attendee).with(request).once
      subject.complete!
    end

    it { is_expected.to have_received(:valid?) }
    it { expect(store[uuid]).to eql({}) }
  end

  describe "#exchange_access_token" do
    let(:totp) { "123456" }
    let(:request) { GetIntoTeachingApiClient::ExistingCandidateRequest.new }
    let(:response) { GetIntoTeachingApiClient::TeachingEventAddAttendee.new }

    before do
      expect_any_instance_of(GetIntoTeachingApiClient::TeachingEventsApi).to \
        receive(:exchange_access_token_for_teaching_event_add_attendee)
        .with(totp, request) { response }
    end

    it "calls exchange_access_token_for_teaching_event_add_attendee" do
      expect(subject.exchange_access_token(totp, request)).to eq(response)
    end
  end
end
