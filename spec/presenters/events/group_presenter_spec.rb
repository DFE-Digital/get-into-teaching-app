require "rails_helper"

describe Events::GroupPresenter do
  let(:application_workshops) { build_list(:event_api, 3, :application_workshop) }
  let(:train_to_teach_events) { build_list(:event_api, 3, :train_to_teach_event) }
  let(:online_events) { build_list(:event_api, 3, :online_event) }
  let(:school_and_university_events) { build_list(:event_api, 3, :school_or_university_event) }
  let(:all_events) { [train_to_teach_events, application_workshops, online_events, school_and_university_events].flatten }

  subject { Events::GroupPresenter.new(all_events) }

  describe "#get_into_teaching_events" do
    context "application workshops" do
      let(:type_id) { GetIntoTeachingApiClient::Constants::EVENT_TYPES["Application Workshop"] }

      specify "should all be present" do
        expect(subject.get_into_teaching_events.fetch(type_id)).to match_array(application_workshops)
      end
    end

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
  end

  describe "#school_and_university_events" do
    let(:unexpected_events) { [application_workshops, train_to_teach_events, online_events].flatten }

    context "school or university events" do
      let(:type_id) { GetIntoTeachingApiClient::Constants::EVENT_TYPES["School or University Event"] }

      specify "should all be present" do
        expect(subject.school_and_university_events.fetch(type_id)).to match_array(school_and_university_events)
      end
    end

    context "get into teaching events, online events and application workshops" do
      let(:get_into_teaching_events) { [application_workshops, train_to_teach_events, online_events].flatten }
      let(:actual_events) { subject.school_and_university_events.values.flatten.map(&:id) }

      specify "are absent" do
        expect(actual_events & get_into_teaching_events).to be_empty
      end
    end
  end

  describe "sorting" do
    context "by event type" do
      let(:application_workshop) { build(:event_api, :application_workshop) }
      let(:train_to_teach_event) { build(:event_api, :train_to_teach_event) }
      let(:online_event) { build(:event_api, :online_event) }
      let(:unsorted_events) { [online_event, train_to_teach_event, application_workshop] }

      subject { Events::GroupPresenter.new(unsorted_events) }

      specify "events should be sorted by their event type" do
        # note these match the order in GetIntoTeachingApiClient::Constants::EVENT_TYPES
        expect(subject.all_events).to eql([train_to_teach_event, online_event, application_workshop])
      end
    end

    context "within an event type" do
      let(:early) { build(:event_api, :application_workshop, start_at: 1.week.from_now) }
      let(:middle) { build(:event_api, :application_workshop, start_at: 2.weeks.from_now) }
      let(:late) { build(:event_api, :application_workshop, start_at: 3.weeks.from_now) }
      let(:unsorted_events) { [middle, late, early] }

      subject { Events::GroupPresenter.new(unsorted_events) }

      specify "events of the same type should be sorted by date" do
        expect(subject.all_events).to eql([early, middle, late])
      end
    end
  end

  describe "capping" do
    let(:type_id) { GetIntoTeachingApiClient::Constants::EVENT_TYPES["Application Workshop"] }
    let(:all_events) { build_list(:event_api, 10, :application_workshop) }
    subject { Events::GroupPresenter.new(all_events, cap: cap).get_into_teaching_events }

    context "when enabled" do
      let(:cap) { true }

      specify "should be capped at the INDEX_PAGE_CAP number" do
        expect(subject.fetch(type_id).size).to eql(Events::GroupPresenter::INDEX_PAGE_CAP)
      end
    end

    context "when not enabled" do
      let(:cap) { false }

      specify "should not be capped (all events are present)" do
        expect(subject.fetch(type_id).size).to eql(all_events.size)
      end
    end
  end
end
