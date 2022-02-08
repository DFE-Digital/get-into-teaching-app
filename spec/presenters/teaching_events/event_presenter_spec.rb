require "rails_helper"

describe TeachingEvents::EventPresenter do
  let(:event) { build(:event_api) }

  subject { described_class.new(event) }

  describe "delegation" do
    %i[
      building
      description
      end_at
      is_in_person
      is_online
      is_virtual
      message
      name
      provider_website_url
      providers_list
      provider_contact_email
      provider_organiser
      provider_target_audience
      provider_website_url
      readable_id
      scribble_id
      start_at
      type_id
      status_id
      video_url
      web_feed_id
    ].each { |attribute| it { is_expected.to delegate_method(attribute).to(:event) } }
  end

  describe "methods" do
    describe "#venue_address" do
      let(:address_parts) do
        [
          event.building.venue,
          event.building.address_line1,
          event.building.address_line2,
          event.building.address_line3,
          event.building.address_city,
          event.building.address_postcode,
        ]
      end

      specify { expect(subject.venue_address).to be_an(Array) }
      specify { expect(subject.venue_address).to include(*address_parts.compact) }
    end

    describe "#has_location?" do
      context "when the event has no building" do
        let(:event) { build(:event_api, :no_location) }

        it { is_expected.not_to have_location }
      end

      context "when the event has a building" do
        let(:event) { build(:event_api) }

        it { is_expected.to have_location }
      end
    end

    describe "#location" do
      context "when show_venue_information? is false" do
        let(:event) { build(:event_api, :virtual) }

        specify { expect(subject.location).to eql(event.building.address_city) }
      end

      context "when show_venue_information? is true" do
        let(:event) { build(:event_api) }
        let(:expected_location) { "#{event.building.venue}, #{event.building.address_city}, #{event.building.address_postcode}" }

        specify { expect(subject.location).to eql(expected_location) }
      end
    end

    describe "#quote" do
      subject { described_class.new(event).quote }

      context "when event is a Train to Teach event" do
        let(:event) { build(:event_api, :train_to_teach_event) }

        specify { expect(subject).to match(/I got answers to questions/) }
      end

      context "when event is a Question Time event" do
        let(:event) { build(:event_api, :question_time_event) }

        specify { expect(subject).to match(/I got answers to questions/) }
      end

      context "when event is a School or University event" do
        let(:event) { build(:event_api, :school_or_university_event) }

        specify { expect(subject).to be_nil }
      end

      context "when event is a Online event" do
        let(:event) { build(:event_api, :online_event) }

        specify { expect(subject).to be_nil }
      end
    end

    describe "#image" do
      subject { described_class.new(event).image }

      context "when event is a Train to Teach event" do
        let(:event) { build(:event_api, :train_to_teach_event) }

        specify { expect(subject.first).to end_with(".jpg") }
        specify { expect(subject.second).to have_key(:alt) }
      end

      context "when event is a Question Time event" do
        let(:event) { build(:event_api, :question_time_event) }

        specify { expect(subject.first).to end_with(".jpg") }
        specify { expect(subject.second).to have_key(:alt) }
      end

      context "when event is a School or University event" do
        let(:event) { build(:event_api, :school_or_university_event) }

        specify { expect(subject).to be_nil }
      end

      context "when event is a Online event" do
        let(:event) { build(:event_api, :online_event) }

        specify { expect(subject).to be_nil }
      end
    end

    describe "#open?" do
      context "when event is open" do
        let(:event) { build(:event_api) }

        it { is_expected.to be_open }
      end

      context "when event is closed" do
        let(:event) { build(:event_api, :closed) }

        it { is_expected.not_to be_open }
      end
    end

    describe "#closed?" do
      context "when event is closed" do
        let(:event) { build(:event_api, :closed) }

        it { is_expected.to be_closed }
      end

      context "when event is open" do
        let(:event) { build(:event_api) }

        it { is_expected.not_to be_closed }
      end
    end

    describe "#show_provider_information?" do
      subject { described_class.new(event).show_provider_information? }

      context "when event is a Train to Teach event" do
        let(:event) { build(:event_api, :train_to_teach_event) }

        specify { expect(subject).to be false }
      end

      context "when event is a Question Time event" do
        let(:event) { build(:event_api, :question_time_event) }

        specify { expect(subject).to be false }
      end

      context "when event is a School or University event" do
        let(:event) { build(:event_api, :school_or_university_event) }

        specify { expect(subject).to be true }
      end

      context "when event is a Online event" do
        let(:event) { build(:event_api, :online_event) }

        specify { expect(subject).to be true }
      end
    end

    describe "#show_venue_information?" do
      subject { described_class.new(event).show_venue_information? }

      context "when the event is online and has no building" do
        let(:event) { build(:event_api, :no_location, is_online: true) }

        it { is_expected.to be false }
      end

      context "when the event is online and has a building" do
        let(:event) { build(:event_api, is_online: true) }

        it { is_expected.to be false }
      end

      context "when the event not online and has no building" do
        let(:event) { build(:event_api, :no_location, is_online: false) }

        it { is_expected.to be false }
      end

      context "when the event not online and has a building" do
        let(:event) { build(:event_api, is_online: false) }

        it { is_expected.to be true }
      end
    end

    describe "#allow_registration?" do
      subject { described_class.new(event).allow_registration? }

      context "when event is a future Train to Teach event" do
        let(:event) { build(:event_api, :train_to_teach_event) }

        specify { expect(subject).to be true }
      end

      context "when event is a future Question Time event" do
        let(:event) { build(:event_api, :question_time_event) }

        specify { expect(subject).to be true }
      end

      context "when event is a past Train to Teach event" do
        let(:event) { build(:event_api, :past, :question_time_event) }

        specify { expect(subject).to be false }
      end

      context "when event is a future non-Train to Teach event" do
        let(:event) { build(:event_api, :school_or_university_event) }

        specify { expect(subject).to be false }
      end
    end
  end
end
