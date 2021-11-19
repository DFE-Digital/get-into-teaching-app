require "rails_helper"

RSpec.feature "Searching for teaching events", type: :feature do
  include_context "with stubbed types api"

  let(:event_count) { 5 }
  let(:events) { build_list(:event_api, event_count) }

  describe "event lists" do
    before do
      allow_any_instance_of(TeachingEvents::Search).to receive(:results).and_return(events)
    end

    scenario "The first two train to teach events are 'featured'" do
      visit teaching_events_path

      expect(page).to have_current_path("/teaching-events")

      expected_featured = 2
      expected_regular = event_count - expected_featured

      # two are featured, rest are just listed
      expect(page).to have_css(".teaching-events__events--featured > ol > li", count: expected_featured)
      expect(page).to have_css(".teaching-events__events--regular > ol > li", count: expected_regular)
    end

    context "when one event is train to teach" do
      let(:ttt_event_count) { 1 }
      let(:events) { build_list(:event_api, event_count - ttt_event_count, :online_event).append(build(:event_api)) }

      scenario "Non-train-to-teach events are never featured" do
        visit teaching_events_path

        expected_featured = ttt_event_count
        expected_regular = event_count - expected_featured

        expect(page).to have_css(".teaching-events__events--featured > ol > li", count: expected_featured)
        expect(page).to have_css(".teaching-events__events--regular > ol > li", count: expected_regular)
      end
    end

    context "when no events are train to teach" do
      let(:events) { build_list(:event_api, event_count, :online_event) }

      scenario "Non-train-to-teach events are never featured" do
        visit teaching_events_path

        expect(page).to have_css(".teaching-events__events--regular > ol > li", count: event_count)
      end
    end

    context "when there's more than one page of events" do
      let(:event_count) { 20 }

      scenario "pagination links should be visible" do
        visit teaching_events_path

        expect(page).to have_css(".pagination")

        click_on "2"

        expect(page).to have_current_path("/teaching-events?page=2")
      end
    end
  end

  describe "page contents when there's one of each kind of event" do
    before do
      allow_any_instance_of(TeachingEvents::Search).to receive(:results).and_return(events)
    end

    subject! { visit teaching_events_path }

    let(:events) do
      [
        # these two types are featurable
        build(:event_api, :train_to_teach_event),
        build(:event_api, :question_time_event),

        # these aren't
        build(:event_api, :online_event),
        build(:event_api, :school_or_university_event),
      ]
    end

    scenario "each event should be listed with the appropriate details" do
      expect(page).to have_css(".event.event--train-to-teach", count: 2)

      expect(page).to have_css(".event .event__info__type", text: "Online forum")
      expect(page).to have_css(".event .event__info__type", text: "Training provider")

      events.each do |event|
        expect(page).to have_link(event.name, href: teaching_event_path(event.readable_id))
      end
    end
  end

  describe "searching for events" do
    let(:events_by_type) { group_events_by_type(events) }
    let(:fake_api) { instance_double(GetIntoTeachingApiClient::TeachingEventsApi, search_teaching_events_grouped_by_type: []) }
    let(:event_types) { GetIntoTeachingApiClient::Constants::EVENT_TYPES }

    before do
      allow(GetIntoTeachingApiClient::TeachingEventsApi).to receive(:new).and_return(fake_api)
    end

    scenario "searching by postcode and distance" do
      visit teaching_events_path

      fill_in "Postcode", with: "M1 2WD"
      select "5 miles", from: "Search area"
      click_on "Update results"

      expect(fake_api).to have_received(:search_teaching_events_grouped_by_type).with(hash_including(postcode: "M1 2WD", radius: 5, online: nil)).once
    end

    scenario "searching for online events" do
      visit teaching_events_path

      check "Online"
      click_on "Update results"

      expect(fake_api).to have_received(:search_teaching_events_grouped_by_type).with(hash_including(online: true)).once
    end

    scenario "searching for in person events" do
      visit teaching_events_path

      check "In person"
      click_on "Update results"

      expect(fake_api).to have_received(:search_teaching_events_grouped_by_type).with(hash_including(online: false)).once
    end

    scenario "searching for train to teach events" do
      visit teaching_events_path

      expected_type_ids = event_types.values_at("Train to Teach event", "Question Time")

      check "Train to Teach"
      click_on "Update results"

      expect(fake_api).to have_received(:search_teaching_events_grouped_by_type).with(hash_including(type_ids: expected_type_ids)).once
    end

    scenario "searching for online forum events" do
      visit teaching_events_path

      expected_type_ids = event_types.values_at("Online event")

      check "Online forum"
      click_on "Update results"

      expect(fake_api).to have_received(:search_teaching_events_grouped_by_type).with(hash_including(type_ids: expected_type_ids)).once
    end

    scenario "searching for school or university events" do
      visit teaching_events_path

      expected_type_ids = event_types.values_at("School or University event")

      check "Training provider"
      click_on "Update results"

      expect(fake_api).to have_received(:search_teaching_events_grouped_by_type).with(hash_including(type_ids: expected_type_ids)).once
    end

    scenario "searching for online and train to teach events" do
      visit teaching_events_path

      expected_type_ids = event_types.values_at("Train to Teach event", "Question Time", "School or University event")

      check "Train to Teach"
      check "Training provider"
      click_on "Update results"

      expect(fake_api).to have_received(:search_teaching_events_grouped_by_type).with(hash_including(type_ids: expected_type_ids)).once
    end
  end
end
