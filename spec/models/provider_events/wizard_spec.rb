require "rails_helper"

RSpec.describe ProviderEvents::Wizard do
  describe ".steps" do
    subject { described_class.steps }

    it {
      is_expected.to eql [
        ProviderEvents::Steps::Email,
        ProviderEvents::Steps::EventName,
        ProviderEvents::Steps::EventDescription,
        ProviderEvents::Steps::OrganisationName,
        ProviderEvents::Steps::EventWebsite,
        ProviderEvents::Steps::TargetAudience,
        ProviderEvents::Steps::EventDate,
        ProviderEvents::Steps::EventTimes,
        ProviderEvents::Steps::EventType,
        ProviderEvents::Steps::OnlinePostcode,
        ProviderEvents::Steps::InPersonLocation,
        ProviderEvents::Steps::NewVenue,
        ProviderEvents::Steps::RegistrationDetails,
        ProviderEvents::Steps::ReviewAnswers,
      ]
    }
  end

  describe "#complete!" do
    subject { described_class.new(wizardstore, current_step) }

    let(:wizardstore) { GITWizard::Store.new store[uuid], {} }
    let(:provider_event) { build(:internal_event, :provider_event) }
    let(:uuid) { SecureRandom.uuid }
    let(:store) do
      { uuid => {
        "provider_contact_email" => "test@test.test",
        "event_date" => Date.new(2999, 7, 8),
        "description" => "Event Description",
        "event_name" => "Event Name",
        "start_time(4i)" => 9,
        "start_time(5i)" => 0,
        "end_time(4i)" => 17,
        "end_time(5i)" => 30,
        "event_type" => "in_person",
        "event_website" => "https://event.test/event",
        "location_option" => "new",
        "venue_name" => "New Venue",
        "address_line_1" => "Address line 1",
        "address_line_2" => "Address line 2",
        "address_line_3" => "Address line 3",
        "address_city" => "Londontown",
        "address_postcode" => "AB1 2CD",
        "organisation_name" => "Organisation Name",
        "registration_option" => "website",
        "registration_website" => "https://register.test/register",
        "target_audience" => "Graduates and undergraduates",
      } }
    end
    let(:current_step) { "review_answers" }
    let(:expected_event_attributes) do
      {
        "provider_contact_email" => "test@test.test",
        "name" => "Event Name",
        "description" => "Event Description",
        "start_at" => Time.utc(2999, 7, 8, 9, 0),
        "end_at" => Time.utc(2999, 7, 8, 17, 30),
        "is_in_person" => true,
        "is_online" => false,
        "is_virtual" => false,

        "provider_organiser" => "Organisation Name",
        "provider_target_audience" => "Graduates and undergraduates",
        "provider_website_url" => "https://event.test/event",
        "readable_id" => readable_id,
        "registration_email_link" => "https://register.test/register",

        "building" => {
          "venue" => "New Venue",
          "addressLine1" => "Address line 1",
          "addressLine2" => "Address line 2",
          "addressLine3" => "Address line 3",
          "addressCity" => "Londontown",
          "addressPostcode" => "AB1 2CD",
        },

        "status_id" => 222_750_003,
        "type_id" => 222_750_009,
      }
    end
    let(:not_found) { GetIntoTeachingApiClient::ApiError.new(code: 404, message: "Not Found") }
    let(:existing_event) { build(:internal_event, :provider_event) }

    before do
      allow(subject).to receive(:valid?).and_return(true)
      allow_any_instance_of(GetIntoTeachingApiClient::TeachingEventsApi).to receive(:upsert_teaching_event).and_return(provider_event)
    end

    context "when there are no duplicate events" do
      let(:readable_id) { "990708-event-name" }

      before do
        allow_any_instance_of(GetIntoTeachingApiClient::TeachingEventsApi).to receive(:get_teaching_event).with(readable_id).and_raise(not_found)
        allow(GetIntoTeachingApiClient::TeachingEvent).to receive(:new).and_call_original
      end

      it "instantiates a new event with the expected parameters" do
        subject.complete!
        expect(GetIntoTeachingApiClient::TeachingEvent).to have_received(:new).with(expected_event_attributes)
      end

      context "with prune! spy" do
        before { allow(wizardstore).to receive(:prune!) }

        it "prunes the store, retaining certain attributes" do
          subject.complete!
          expect(wizardstore).to have_received(:prune!).with({ leave: %w[provider_contact_email reference_number] }).once
        end
      end

      it "checks the wizard is valid" do
        subject.complete!
        is_expected.to have_received(:valid?)
      end

      it "prunes the store, retaining certain attributes" do
        subject.complete!
        expect(store[uuid]).to eql({
          "provider_contact_email" => "test@test.test",
          "reference_number" => "A1234",
        })
      end
    end

    context "when there are a few existing duplicate events" do
      let(:readable_id) { "990708-event-name-4" }

      before do
        allow_any_instance_of(GetIntoTeachingApiClient::TeachingEventsApi).to receive(:get_teaching_event).with("990708-event-name").and_return(existing_event)
        allow_any_instance_of(GetIntoTeachingApiClient::TeachingEventsApi).to receive(:get_teaching_event).with("990708-event-name-2").and_return(existing_event)
        allow_any_instance_of(GetIntoTeachingApiClient::TeachingEventsApi).to receive(:get_teaching_event).with("990708-event-name-3").and_return(existing_event)
        allow_any_instance_of(GetIntoTeachingApiClient::TeachingEventsApi).to receive(:get_teaching_event).with("990708-event-name-4").and_raise(not_found)
        allow(GetIntoTeachingApiClient::TeachingEvent).to receive(:new).and_call_original
      end

      it "instantiates a new event with the expected parameters" do
        subject.complete!
        expect(GetIntoTeachingApiClient::TeachingEvent).to have_received(:new).with(expected_event_attributes)
      end
    end

    context "when there are too many existing duplicate events" do
      before do
        allow_any_instance_of(GetIntoTeachingApiClient::TeachingEventsApi).to receive(:get_teaching_event).with("990708-event-name").and_return(existing_event)
        (2..20).each do |i|
          allow_any_instance_of(GetIntoTeachingApiClient::TeachingEventsApi).to receive(:get_teaching_event).with("990708-event-name-#{i}").and_return(existing_event)
        end

        allow(GetIntoTeachingApiClient::TeachingEvent).to receive(:new).and_call_original
      end

      it "raises an error" do
        expect { subject.complete! }.to raise_error("Unable to generate unique readable id for 990708-event-name")
      end
    end
  end
end
