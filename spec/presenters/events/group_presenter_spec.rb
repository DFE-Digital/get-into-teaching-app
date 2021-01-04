require "rails_helper"

describe Events::GroupPresenter do
  let(:train_to_teach_events) { build_list(:event_api, 3, :train_to_teach_event) }
  let(:online_events) { build_list(:event_api, 3, :online_event) }
  let(:school_and_university_events) { build_list(:event_api, 3, :school_or_university_event) }
  let(:all_events) { [train_to_teach_events, online_events, school_and_university_events].flatten }
  let(:events_by_type) { all_events.group_by(&:type_id) }
  let(:display_empty_types) { false }

  subject { described_class.new(events_by_type, display_empty_types) }

  describe "#sorted_events_by_type" do
    let(:type_ids) { subject.sorted_events_by_type.map(&:first) }
    let(:online_event_type_id) { GetIntoTeachingApiClient::Constants::EVENT_TYPES["Online Event"] }

    it "returns events_by_type wrapped in an array by default" do
      expect(subject.sorted_events_by_type.to_h).to eq(events_by_type)
    end

    it "sorts event types according to GetIntoTeachingApiClient::Constants::EVENT_TYPES" do
      expect(type_ids).to eq(GetIntoTeachingApiClient::Constants::EVENT_TYPES.values)
    end

    context "when there are no events for a type" do
      let(:online_events) { [] }

      it "does not contain a key for that type" do
        expect(subject.sorted_events_by_type[online_event_type_id]).to be_nil
      end
    end

    context "when display_empty_types is true" do
      let(:display_empty_types) { true }
      let(:online_events) { [] }

      it "contains a key for types that have no events" do
        expect(type_ids).to include(online_event_type_id)
      end
    end

    context "sorting within an event type" do
      let(:early) { build(:event_api, :online_event, start_at: 1.week.from_now) }
      let(:middle) { build(:event_api, :online_event, start_at: 2.weeks.from_now) }
      let(:late) { build(:event_api, :online_event, start_at: 3.weeks.from_now) }
      let(:type_id) { GetIntoTeachingApiClient::Constants::EVENT_TYPES["Online Event"] }
      let(:unsorted_events) { [middle, late, early] }

      subject { described_class.new({ type_id => unsorted_events }) }

      it "sorts events of the same type by date" do
        expect(subject.sorted_events_by_type.to_h[type_id]).to eql([early, middle, late])
      end
    end
  end
end
