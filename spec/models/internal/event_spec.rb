require "rails_helper"

describe Internal::Event do
  describe "attributes" do
    it { is_expected.to respond_to :id }
    it { is_expected.to respond_to :name }
    it { is_expected.to respond_to :summary }
    it { is_expected.to respond_to :description }
    it { is_expected.to respond_to :building }
    it { is_expected.to respond_to :is_online }
    it { is_expected.to respond_to :start_at }
    it { is_expected.to respond_to :end_at }
    it { is_expected.to respond_to :provider_contact_email }
    it { is_expected.to respond_to :provider_organiser }
    it { is_expected.to respond_to :provider_target_audience }
    it { is_expected.to respond_to :provider_website_url }
  end

  describe "validations" do
    let(:now) { Time.zone.now }

    describe "#name" do
      it { is_expected.to allow_value("test").for :name }
      it { is_expected.to_not allow_values("", nil).for :name }
    end

    describe "#summary" do
      it { is_expected.to allow_value("test").for :summary }
      it { is_expected.to_not allow_values("", nil).for :summary }
    end

    describe "#description" do
      it { is_expected.to allow_value("test").for :description }
      it { is_expected.to_not allow_values("", nil).for :description }
    end

    describe "#is_online" do
      it { is_expected.to allow_values(true, false).for :is_online }
      it { is_expected.to_not allow_value(nil).for :is_online }
    end

    describe "#start_at" do
      it { is_expected.to_not allow_values(nil, now - 1.minute, now).for :start_at }
      it { is_expected.to allow_value(Time.zone.now + 1.minute).for :start_at }
    end

    describe "#end_at" do
      it { is_expected.to_not allow_values(nil, now - 1.minute, now).for :end_at }
      it { is_expected.to allow_value(now + 1.minute).for :end_at }

      it "is expected not to allow end at to be the same as start at" do
        subject.start_at = now + 1.minute
        is_expected.to_not allow_value(subject.start_at).for :end_at
      end

      it "is expected not to allow end at to be earlier than start at" do
        subject.start_at = now + 2.minutes
        is_expected.to_not allow_value(now + 1.minute).for :end_at
      end

      it "is expected to allow end at to be later than start at" do
        subject.start_at = now + 1.minute
        is_expected.to allow_value(now + 2.minutes).for :end_at
      end
    end

    describe "#provider contact email" do
      it { is_expected.to allow_value("test@test.com").for :provider_contact_email }
      it { is_expected.to_not allow_values("test", "", nil).for :provider_contact_email }
      it { is_expected.to validate_length_of(:provider_contact_email).is_at_most(100) }
    end

    describe "#provider organiser" do
      it { is_expected.to allow_value("test").for :provider_organiser }
      it { is_expected.to_not allow_value("", nil).for :provider_organiser }
    end

    describe "#provider target audience" do
      it { is_expected.to allow_value("test").for :provider_target_audience }
      it { is_expected.to_not allow_value("", nil).for :provider_target_audience }
    end

    describe "#provider website url" do
      it { is_expected.to allow_value("test").for :provider_website_url }
      it { is_expected.to_not allow_value("", nil).for :provider_website_url }
    end
  end

  describe "#initialize_with_api_event" do
    context "with GetIntoTeachingApiClient::TeachingEvent" do
      let(:api_event) { build(:event_api) }
      let(:expected_attributes) do
        attributes_for(
          :event_api,
          id: api_event.id,
          name: api_event.name,
          readable_id: api_event.readable_id,
          status_id: api_event.status_id,
          summary: api_event.summary,
          description: api_event.description,
          is_online: api_event.is_online,
          start_at: api_event.start_at,
          end_at: api_event.end_at,
          provider_contact_email: api_event.provider_contact_email,
          provider_organiser: api_event.provider_organiser,
          provider_target_audience: api_event.provider_target_audience,
          provider_website_url: api_event.provider_website_url,
        ).slice(described_class.attribute_names)
      end
      context "with building" do
        let(:expected_building_attributes) { attributes_for(:event_building_api, id: api_event.building.id) }

        it "has correct attributes" do
          expected_attributes["venue_type"] = Internal::Event::VENUE_TYPES[:existing]
          internal_event = described_class.initialize_with_api_event(api_event)

          expect(internal_event).to have_attributes(expected_attributes)
          expect(internal_event.building).to have_attributes(expected_building_attributes)
        end
      end

      context "without building" do
        it "has correct attributes" do
          api_event.building = nil
          expected_attributes["venue_type"] = Internal::Event::VENUE_TYPES[:none]
          internal_event = described_class.initialize_with_api_event(api_event)

          expect(internal_event).to have_attributes(expected_attributes)
          expect(internal_event.building).to be_nil
        end
      end
    end
  end

  describe "#to_api_event" do
    let(:internal_event) { build(:internal_event) }
    let(:expected_attributes) do
      attributes_for(
        :event_api,
        id: internal_event.id,
        name: internal_event.name,
        readable_id: internal_event.readable_id,
        status_id: internal_event.status_id,
        type_id: GetIntoTeachingApiClient::Constants::EVENT_TYPES["School or University event"],
        summary: internal_event.summary,
        description: internal_event.description,
        is_online: internal_event.is_online,
        start_at: internal_event.start_at,
        end_at: internal_event.end_at,
        provider_contact_email: internal_event.provider_contact_email,
        provider_organiser: internal_event.provider_organiser,
        provider_target_audience: internal_event.provider_target_audience,
        provider_website_url: internal_event.provider_website_url,
      ).slice(described_class.attribute_names)
    end
    let(:expected_building_attributes) do
      attributes_for(
        :event_building_api,
        id: internal_event.building.id,
        venue: internal_event.building.venue,
        address_line1: internal_event.building.address_line1,
        address_line2: internal_event.building.address_line2,
        address_line3: internal_event.building.address_line3,
        address_city: internal_event.building.address_city,
        address_postcode: internal_event.building.address_postcode,
      )
    end

    context "when passed a building" do
      it "has correct attributes" do
        api_event = internal_event.to_api_event
        expect(api_event.building).to have_attributes(expected_building_attributes)
      end
    end

    context "when passed a event" do
      it "has correct attributes" do
        api_event = internal_event.to_api_event
        expect(api_event).to have_attributes(expected_attributes)
      end
    end

    context "when passed an event with blank id" do
      it "has no id field" do
        internal_event.id = ""
        api_event = internal_event.to_api_event

        expect(api_event.id).to be_nil
      end
    end
  end
end
