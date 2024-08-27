require "rails_helper"

RSpec.feature "Searching for teaching events", type: :feature do
  let(:event_count) { 5 }
  let(:events) { build_list(:event_api, event_count) }

  describe "filter contents" do
    before do
      allow_any_instance_of(TeachingEvents::Search).to receive(:results).and_return(events)
      visit events_path
    end

    specify "the events filter contains valid event query params" do
      html = Nokogiri.parse(page.html)

      params = html
        .css(%(input[type='checkbox'][name='teaching_events_search[type][]']))
        .map { |e| e.attr("value") }
        .flat_map { |qp| qp.split(",") }

      expect(params).to match_array(Crm::EventType::QUERY_PARAM_NAMES.keys.reject { |a| a == "onlineqa" })
    end
  end

  describe "event lists" do
    before do
      allow_any_instance_of(TeachingEvents::Search).to receive(:results).and_return(events)
    end

    scenario "The first two get into teaching events are 'featured'" do
      visit events_path

      expect(page).to have_current_path("/events")

      expected_featured = 2
      expected_regular = event_count - expected_featured

      # two are featured, rest are just listed
      expect(page).to have_css(".teaching-events__events--featured > ol > li", count: expected_featured)
      expect(page).to have_css(".teaching-events__events--regular > ol > li", count: expected_regular)
    end

    context "when one event is get into teaching" do
      let(:git_event_count) { 1 }
      let(:events) { build_list(:event_api, event_count - git_event_count, :online_event).append(build(:event_api)) }

      scenario "Non-get-into-teaching events are never featured" do
        visit events_path

        expected_featured = git_event_count
        expected_regular = event_count - expected_featured

        expect(page).to have_css(".teaching-events__events--featured > ol > li", count: expected_featured)
        expect(page).to have_css(".teaching-events__events--regular > ol > li", count: expected_regular)
      end
    end

    context "when no events are get into teaching" do
      let(:events) { build_list(:event_api, event_count, :online_event) }

      scenario "Non-get-into-teaching events are never featured" do
        visit events_path

        expect(page).to have_css(".teaching-events__events--regular > ol > li", count: event_count)
      end
    end

    context "when there's more than one page of events" do
      let(:event_count) { 20 }

      scenario "pagination links should be visible" do
        visit events_path

        expect(page).to have_css(".pagination")

        click_on "2"

        expect(page).to have_current_path("/events?page=2")
      end
    end
  end

  describe "page contents when there's one of each kind of event" do
    before do
      allow_any_instance_of(TeachingEvents::Search).to receive(:results).and_return(events)
    end

    subject! { visit events_path }

    let(:events) do
      [
        # these two types are featurable
        build(:event_api, :get_into_teaching_event),

        # these aren't
        build(:event_api, :online_event),
        build(:event_api, :school_or_university_event),
      ]
    end

    scenario "each event should be listed with the appropriate details" do
      expect(page).to have_css(".event.event--get-into-teaching", count: 1)

      expect(page).to have_css(".event .event__info__type", text: "DfE Online Q&A")
      expect(page).to have_css(".event .event__info__type", text: "Training provider")

      events.each do |event|
        expect(page).to have_link(event.name, href: event_path(event.readable_id))
      end
    end

    scenario "there is a link for event organisers to add their own events" do
      expect(page).to have_content("Do you have a teaching event?")
      expect(page).to have_link("please fill in our online form", href: "https://form.education.gov.uk/service/Provider-event-details---Get-into-Teaching-website")
    end
  end

  describe "searching for events" do
    let(:fake_api) { instance_double(GetIntoTeachingApiClient::TeachingEventsApi, search_teaching_events: []) }

    before do
      allow(GetIntoTeachingApiClient::TeachingEventsApi).to receive(:new).and_return(fake_api)
      allow(fake_api).to receive(:search_teaching_events) { events }
    end

    scenario "searching by postcode and distance" do
      visit events_path

      fill_in "Postcode", with: "M1 2WD"
      select "5 miles", from: "Search area"
      click_on "Update results"

      expect(fake_api).to have_received(:search_teaching_events).with(hash_including(postcode: "M1 2WD", radius: 5, online: nil)).once
    end

    scenario "searching for online events" do
      visit events_path

      check "Online"
      click_on "Update results"

      expect(fake_api).to have_received(:search_teaching_events).with(hash_including(online: true)).once
    end

    scenario "searching for in person events" do
      visit events_path

      check "In person"
      click_on "Update results"

      expect(fake_api).to have_received(:search_teaching_events).with(hash_including(online: false)).once
    end

    scenario "searching for get into teaching events" do
      visit events_path

      expected_type_ids = Crm::EventType.lookup_by_names("Get Into Teaching event")

      check "DfE Get Into Teaching"
      click_on "Update results"

      expect(fake_api).to have_received(:search_teaching_events).with(hash_including(type_ids: expected_type_ids)).once
    end

    scenario "searching for school or university events" do
      visit events_path

      expected_type_ids = [Crm::EventType.school_or_university_event_id]

      check "Training provider"
      click_on "Update results"

      expect(fake_api).to have_received(:search_teaching_events).with(hash_including(type_ids: expected_type_ids)).once
    end

    scenario "searching for online and get into teaching events" do
      visit events_path

      expected_type_ids = Crm::EventType.lookup_by_names("Get Into Teaching event", "School or University event")

      check "DfE Get Into Teaching"
      check "Training provider"
      click_on "Update results"

      expect(fake_api).to have_received(:search_teaching_events).with(hash_including(type_ids: expected_type_ids)).once
    end

    context "when no events are found" do
      let(:event_count) { 0 }
      let(:params) { nil }
      let(:national_git_events) { [] }

      before do
        get_into_teaching_type_ids = Crm::EventType.lookup_by_names("Get Into Teaching event")
        allow(fake_api).to receive(:search_teaching_events)
          .with(hash_including(type_ids: get_into_teaching_type_ids)) { national_git_events }

        visit events_path(params)
      end

      scenario "a useful message and options are shown" do
        within(".teaching-events__events--none") do
          expect(page).to have_css("h2", text: "0 events found")
          expect(page).to have_css("p", text: "Why not try:")
          expect(page).to have_link(text: "clearing your filters", href: events_path)
        end

        expect(page).not_to have_css("teaching-events__events--regular")
      end

      context "when there are upcoming national Get Into Teaching events" do
        let(:national_git_events) { build_list(:event_api, 1, :online) }

        scenario "they are displayed as events of interest" do
          within(".teaching-events__events--regular") do
            expect(page).to have_css("h2", text: "Other events you may be interested in")
          end
        end
      end

      context "when the candidate has filtered by distance" do
        let(:params) { { teaching_events_search: { distance: 5 } } }

        scenario "an alternate option is shown" do
          within(".teaching-events__events--none") do
            expect(page).to have_css("li", text: "expanding your search area")
          end
        end
      end

      context "when the candidate has filtered by in-person only" do
        let(:params) { { teaching_events_search: { distance: 5, online: [false] } } }

        scenario "an alternate option is shown" do
          within(".teaching-events__events--none") do
            add_online_events_path = events_path(
              params.deep_merge({ teaching_events_search: { online: [false, true] } }),
            )
            expect(page).to have_link(text: "online events", href: add_online_events_path)
          end
        end
      end
    end
  end
end
