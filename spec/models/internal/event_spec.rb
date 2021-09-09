require "rails_helper"

describe Internal::Event do
  describe "attributes" do
    it { is_expected.to respond_to :id }
    it { is_expected.to respond_to :name }
    it { is_expected.to respond_to :readable_id }
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
      it { is_expected.not_to allow_values("", nil).for :name }
      it { is_expected.to validate_length_of(:name).is_at_most(300) }
    end

    describe "#readable_id" do
      it { is_expected.to allow_value("test").for :readable_id }
      it { is_expected.not_to allow_values("", nil).for :readable_id }
      it { is_expected.to validate_length_of(:readable_id).is_at_most(300) }
    end

    describe "#summary" do
      it { is_expected.to allow_value("test").for :summary }
      it { is_expected.not_to allow_values("", nil).for :summary }
      it { is_expected.to validate_length_of(:summary).is_at_most(1000) }
    end

    describe "#description" do
      it { is_expected.to allow_value("test").for :description }
      it { is_expected.not_to allow_values("", nil).for :description }
      it { is_expected.to validate_length_of(:description).is_at_most(2000) }
    end

    describe "#start_at" do
      it { is_expected.not_to allow_values(nil, now - 1.minute, now).for :start_at }
      it { is_expected.to allow_value(Time.zone.now + 1.minute).for :start_at }
    end

    describe "#end_at" do
      it { is_expected.not_to allow_values(nil, now - 1.minute, now).for :end_at }
      it { is_expected.to allow_value(now + 1.minute).for :end_at }

      it "is expected not to allow end at to be the same as start at" do
        subject.start_at = now + 1.minute
        is_expected.not_to allow_value(subject.start_at).for :end_at
      end

      it "is expected not to allow end at to be earlier than start at" do
        subject.start_at = now + 2.minutes
        is_expected.not_to allow_value(now + 1.minute).for :end_at
      end

      it "is expected to allow end at to be later than start at" do
        subject.start_at = now + 1.minute
        is_expected.to allow_value(now + 2.minutes).for :end_at
      end
    end

    context "when online event" do
      before { allow(subject).to receive(:online_event?).and_return(true) }

      describe "#scribble_id" do
        it { is_expected.to allow_values("test", "", nil).for :scribble_id }
        it { is_expected.to validate_length_of(:scribble_id).is_at_most(300) }
      end
    end

    context "when provider event" do
      before { allow(subject).to receive(:provider_event?).and_return(true) }

      describe "#is_online" do
        it { is_expected.to allow_values(true, false).for :is_online }
        it { is_expected.not_to allow_value(nil).for :is_online }
      end

      describe "#provider contact email" do
        it { is_expected.to allow_value("test@test.com").for :provider_contact_email }
        it { is_expected.not_to allow_values("test", "", nil).for :provider_contact_email }
        it { is_expected.to validate_length_of(:provider_contact_email).is_at_most(100) }
      end

      describe "#provider organiser" do
        it { is_expected.to allow_value("test").for :provider_organiser }
        it { is_expected.not_to allow_value("", nil).for :provider_organiser }
        it { is_expected.to validate_length_of(:provider_organiser).is_at_most(300) }
      end

      describe "#provider target audience" do
        it { is_expected.to allow_value("test").for :provider_target_audience }
        it { is_expected.not_to allow_value("", nil).for :provider_target_audience }
        it { is_expected.to validate_length_of(:provider_target_audience).is_at_most(500) }
      end

      describe "#provider website url" do
        it { is_expected.to allow_value("test").for :provider_website_url }
        it { is_expected.not_to allow_value("", nil).for :provider_website_url }
        it { is_expected.to validate_length_of(:provider_website_url).is_at_most(300) }
      end
    end

    describe "#venue_type" do
      it { is_expected.to allow_values(described_class::VENUE_TYPES.values).for :venue_type }
      it { is_expected.not_to allow_values(:other, nil, "").for :venue_type }

      context "when building is nil" do
        before { subject.building = nil }

        it { is_expected.not_to allow_value(described_class::VENUE_TYPES[:existing]).for :venue_type }
      end

      context "when building.id is nil" do
        before { subject.building = build(:event_building, id: nil) }

        it { is_expected.not_to allow_value(described_class::VENUE_TYPES[:existing]).for :venue_type }
      end
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
          expected_attributes["venue_type"] = described_class::VENUE_TYPES[:existing]
          internal_event = described_class.initialize_with_api_event(api_event)

          expect(internal_event).to have_attributes(expected_attributes)
          expect(internal_event.building).to have_attributes(expected_building_attributes)
        end
      end

      context "without building" do
        it "has correct attributes" do
          api_event.building = nil
          expected_attributes["venue_type"] = described_class::VENUE_TYPES[:none]
          internal_event = described_class.initialize_with_api_event(api_event)

          expect(internal_event).to have_attributes(expected_attributes)
          expect(internal_event.building).to be_nil
        end
      end
    end
  end

  describe "#to_api_event" do
    let(:internal_event) { build(:internal_event, :provider_event) }
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

  describe "#type_id=" do
    context "when event is initialised with 'online' event_type" do
      subject { described_class.new({ type_id: GetIntoTeachingApiClient::Constants::EVENT_TYPES["Online event"] }) }

      it "sets 'is_online' to true" do
        expect(subject.is_online).to be true
      end
    end
  end

  describe "#save" do
    subject { described_class.new }

    context "when the result is invalid" do
      it "returns false" do
        allow_any_instance_of(described_class).to receive(:invalid?) { true }
        expect(described_class.new.save).to be false
      end
    end

    context "when the result is valid" do
      context "when the API raises a 400 error" do
        let(:error_message) { "Must be unique" }
        let(:json_error) { JSON[errors: { ReadableId: [error_message] }] }
        let(:api_error) { GetIntoTeachingApiClient::ApiError.new(code: 400, response_body: json_error) }

        before do
          allow_any_instance_of(described_class).to receive(:invalid?) { false }

          allow_any_instance_of(GetIntoTeachingApiClient::TeachingEventsApi)
            .to receive(:upsert_teaching_event) { raise api_error }
        end

        it "adds the error to the correct attribute" do
          subject.save

          expect(subject.errors["readable_id"].first).to eq(error_message)
        end

        it "returns false" do
          expect(subject.save).to be false
        end
      end

      context "when the API raises a server error" do
        subject { described_class.new }

        let(:api_error) { GetIntoTeachingApiClient::ApiError.new(code: 500) }

        before do
          allow_any_instance_of(described_class).to receive(:invalid?) { false }

          allow_any_instance_of(GetIntoTeachingApiClient::TeachingEventsApi)
            .to receive(:upsert_teaching_event).and_raise(api_error)
        end

        it "re-raises the error" do
          expect { subject.save }.to raise_error api_error
        end
      end
    end
  end

  describe "#buildings" do
    let(:building) { build(:event_building_api) }

    it "fetches buildings if they are nil" do
      expect_any_instance_of(GetIntoTeachingApiClient::TeachingEventBuildingsApi)
        .to receive(:get_teaching_event_buildings)

      described_class.new.buildings
    end

    it "only fetches buildings once" do
      expect_any_instance_of(GetIntoTeachingApiClient::TeachingEventBuildingsApi)
        .to receive(:get_teaching_event_buildings).once.and_return([build(:event_building_api)])

      event = described_class.new
      2.times { event.buildings }
    end
  end

  describe "#assign_building" do
    context "when the venue type is existing" do
      context "when id is present" do
        let(:building) { build(:event_building_api) }
        let(:attributes) { attributes_for(:event_building_api, id: building.id) }

        it "sets building based on id" do
          event = described_class.new
          event.venue_type = described_class::VENUE_TYPES[:existing]
          allow(event).to receive(:buildings) { [building] }
          event.assign_building(building.to_hash)
          expect(event.building).to have_attributes(attributes)
        end

        context "when id is not present" do
          let(:building) { build(:event_building_api, id: nil) }

          it "returns nil" do
            event = described_class.new
            event.venue_type = described_class::VENUE_TYPES[:existing]
            expect(event.assign_building(building.to_hash)).to be_nil
          end
        end
      end
    end

    context "when the venue type is add and an id is present" do
      let(:building) { attributes_for(:event_building) }

      it "sets building with no id" do
        event = described_class.new
        event.venue_type = described_class::VENUE_TYPES[:add]
        event.assign_building(building.to_hash)

        expect(event.building).to have_attributes(building.except(:id))
      end
    end

    context "when the venue type is none" do
      let(:building) { attributes_for(:event_building) }

      it "returns nil" do
        event = described_class.new
        event.venue_type = described_class::VENUE_TYPES[:none]
        expect(event.assign_building(building.to_hash)).to be_nil
      end
    end
  end

  describe "#invalid" do
    let(:event) { build(:internal_event, :provider_event, venue_type: described_class::VENUE_TYPES[:none]) }

    context "when event is valid" do
      it "returns false when building is invalid" do
        allow_any_instance_of(Internal::EventBuilding).to receive(:invalid?) { true }
        expect(event.invalid?).to be true
      end

      it "returns true when building is nil" do
        event.building = nil
        expect(event.invalid?).to be false
      end

      it "returns false when building is valid" do
        event.venue_type = described_class::VENUE_TYPES[:existing]
        allow_any_instance_of(Internal::EventBuilding).to receive(:invalid?) { false }
        expect(event.invalid?).to be false
      end
    end

    context "when event is invalid" do
      it "returns true" do
        allow_any_instance_of(described_class).to receive(:invalid?) { true }
        expect(event.invalid?).to be true
      end
    end
  end
end
