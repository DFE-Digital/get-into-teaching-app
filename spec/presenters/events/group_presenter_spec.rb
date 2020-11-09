require "rails_helper"

describe Events::GroupPresenter do
  let(:train_to_teach_events) { build_list(:event_api, 3, :train_to_teach_event) }
  let(:online_events) { build_list(:event_api, 3, :online_event) }
  let(:school_and_university_events) { build_list(:event_api, 3, :school_or_university_event) }
  let(:all_events) { [train_to_teach_events, online_events, school_and_university_events].flatten }
  let(:events_by_type) { all_events.group_by { |event| event.type_id.to_s.to_sym } }
  let(:display_empty_types) { false }

  subject { Events::GroupPresenter.new(events_by_type, display_empty_types) }

  describe "#get_into_teaching_events" do
    context "train to teach events" do
      let(:type_id) { GetIntoTeachingApiClient::Constants::EVENT_TYPES["Train to Teach Event"] }

      specify "should all be present" do
        expect(subject.get_into_teaching_events.fetch(type_id)).to match_array(train_to_teach_events)
      end
    end

    context "online events" do
      let(:type_id) { GetIntoTeachingApiClient::Constants::EVENT_TYPES["Online Event"] }

      specify "should all be present" do
        expect(subject.get_into_teaching_events.fetch(type_id)).to match_array(online_events)
      end
    end

    context "school or university events" do
      let(:actual_events) { subject.get_into_teaching_events.values.flatten.map(&:id) }

      specify "are absent" do
        expect(actual_events & school_and_university_events).to be_empty
      end
    end

    context "when there are no events" do
      let(:train_to_teach_events) { [] }
      let(:online_events) { [] }

      specify "contains a key for each event type mapping to an empty array" do
        keys = GetIntoTeachingApiClient::Constants::GET_INTO_TEACHING_EVENT_TYPES.values
        expect(subject.get_into_teaching_events).to eq(keys.product([[]]).to_h)
      end
    end
  end

  describe "#display_empty_types?" do
    it "defaults to false" do
      expect(Events::GroupPresenter.new({})).to_not be_display_empty_types
    end
  end

  describe "#display_get_into_teaching_events?" do
    it { expect(subject).to be_display_get_into_teaching_events }

    context "when there are no get into teaching events" do
      let(:train_to_teach_events) { [] }
      let(:online_events) { [] }

      it { expect(subject).to_not be_display_get_into_teaching_events }

      context "when display_empty_types is true" do
        let(:display_empty_types) { true }

        it { expect(subject).to be_display_get_into_teaching_events }
      end
    end
  end

  describe "#display_school_and_university_events?" do
    it { expect(subject).to be_display_school_and_university_events }

    context "when there are no get into teaching events" do
      let(:school_and_university_events) { [] }

      it { expect(subject).to_not be_display_school_and_university_events }

      context "when display_empty_types is true" do
        let(:display_empty_types) { true }

        it { expect(subject).to be_display_school_and_university_events }
      end
    end
  end

  describe "#school_and_university_events" do
    let(:unexpected_events) { [train_to_teach_events, online_events].flatten }

    context "school or university events" do
      let(:type_id) { GetIntoTeachingApiClient::Constants::EVENT_TYPES["School or University Event"] }

      specify "should all be present" do
        expect(subject.school_and_university_events.fetch(type_id)).to match_array(school_and_university_events)
      end
    end

    context "get into teaching events and online events" do
      let(:get_into_teaching_events) { [train_to_teach_events, online_events].flatten }
      let(:actual_events) { subject.school_and_university_events.values.flatten.map(&:id) }

      specify "are absent" do
        expect(actual_events & get_into_teaching_events).to be_empty
      end
    end

    context "when there are no events" do
      let(:school_and_university_events) { [] }

      specify "contains a key for schools or university events mapping to an empty array" do
        expect(subject.school_and_university_events).to eq({
          GetIntoTeachingApiClient::Constants::EVENT_TYPES["School or University Event"] => [],
        })
      end
    end
  end

  describe "sorting" do
    context "within an event type" do
      let(:early) { build(:event_api, :online_event, start_at: 1.week.from_now) }
      let(:middle) { build(:event_api, :online_event, start_at: 2.weeks.from_now) }
      let(:late) { build(:event_api, :online_event, start_at: 3.weeks.from_now) }
      let(:type_id) { GetIntoTeachingApiClient::Constants::EVENT_TYPES["Online Event"] }
      let(:unsorted_events) { [middle, late, early] }

      subject { Events::GroupPresenter.new({ type_id => unsorted_events }) }

      specify "events of the same type should be sorted by date" do
        expect(subject.events_by_type[type_id]).to eql([early, middle, late])
      end
    end
  end
end
