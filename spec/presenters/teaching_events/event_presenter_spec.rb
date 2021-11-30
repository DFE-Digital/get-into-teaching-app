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
      is_online
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
  end
end
