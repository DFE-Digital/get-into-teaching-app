require "rails_helper"

describe Events::Wizard do
  describe ".steps" do
    subject { described_class.steps }

    it do
      is_expected.to eql [
        Events::Steps::PersonalDetails,
        Events::Steps::Authenticate,
        Events::Steps::ContactDetails,
        Events::Steps::FurtherDetails,
        Events::Steps::PersonalisedUpdates,
      ]
    end
  end

  describe "#complete!" do
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
    let(:request) do
      GetIntoTeachingApiClient::TeachingEventAddAttendee.new(
        { eventId: "abc123", email: "email@address.com", firstName: "Joe", lastName: "Joseph" },
      )
    end

    subject { described_class.new wizardstore, "personalised_updates" }

    before { allow(subject).to receive(:valid?).and_return true }
    before do
      expect_any_instance_of(GetIntoTeachingApiClient::TeachingEventsApi).to \
        receive(:add_teaching_event_attendee).with(request).once
    end
    before { subject.complete! }

    it { is_expected.to have_received(:valid?) }
    it { expect(store[uuid]).to eql({}) }
  end
end
