require "rails_helper"
require "action_text/system_test_helper"

RSpec.feature "Internal section", type: :feature do
  let(:types) { Events::Search.available_event_type_ids }
  let(:events) do
    1.times.collect do |index|
      start_at = Time.zone.today.at_end_of_month - index.days
      type_id = types[index % types.count]
      status_id = GetIntoTeachingApiClient::Constants::EVENT_STATUS["Pending"]
      build(:event_api,
            :with_provider_info,
            name: "Event #{index + 1}",
            start_at: start_at,
            type_id: type_id,
            status_id: status_id)
    end
  end
  let(:events_by_type) { group_events_by_type(events) }

  before do
    if page.driver.browser.respond_to?(:authorize)
      page.driver.browser.authorize(ENV["PUBLISHER_USERNAME"], ENV["PUBLISHER_PASSWORD"])
    end

    allow_any_instance_of(GetIntoTeachingApiClient::TeachingEventsApi).to \
      receive(:search_teaching_events_grouped_by_type) { events_by_type }

    allow_any_instance_of(GetIntoTeachingApiClient::TeachingEventBuildingsApi).to \
      receive(:get_teaching_event_buildings) { [] }
  end

  scenario "Submit a new form" do
    allow_any_instance_of(GetIntoTeachingApiClient::TeachingEventsApi).to \
      receive(:upsert_teaching_event) { [] }

    navigate_to_new_submission

    enter_valid_event_details

    click_button "Submit for review"
    expect(page).to have_text "Event submitted for review"
  end

  scenario "Edit a pending event with no building" do
    allow_any_instance_of(GetIntoTeachingApiClient::TeachingEventsApi).to \
      receive(:upsert_teaching_event) { [] }

    allow_any_instance_of(GetIntoTeachingApiClient::TeachingEventsApi).to \
      receive(:get_teaching_event) { events[0] }

    events[0].building = nil

    navigate_to_edit_form

    expect(page).to have_checked_field("No venue")

    click_button "Submit for review"
    expect(page).to have_text "Event submitted for review"
  end

  scenario "Edit a pending event with building" do
    allow_any_instance_of(GetIntoTeachingApiClient::TeachingEventsApi).to \
      receive(:upsert_teaching_event) { [] }

    allow_any_instance_of(GetIntoTeachingApiClient::TeachingEventsApi).to \
      receive(:get_teaching_event) { events[0] }

    navigate_to_edit_form

    expect(page).to have_checked_field("Search existing venues")
  end

  scenario "Final submit" do
    allow_any_instance_of(GetIntoTeachingApiClient::TeachingEventsApi).to \
      receive(:upsert_teaching_event) { [] }

    allow_any_instance_of(GetIntoTeachingApiClient::TeachingEventsApi).to \
      receive(:get_teaching_event) { events[0] }

    visit internal_events_path
    expect(page).to have_text "Pending Provider Events"

    click_link "Event 1"
    expect(page).to have_text("This is a pending event")

    click_button "Submit this provider event"
    expect(page).to have_text("Event submitted")
  end

  describe "validations" do
    scenario "There are validation errors on event and building" do
      allow_any_instance_of(GetIntoTeachingApiClient::TeachingEventsApi).to \
        receive(:upsert_teaching_event) { [] }

      navigate_to_new_submission

      fill_in "internal_event[start_at]", with: 1.day.ago
      fill_in "internal_event[end_at]", with: 1.day.ago

      choose "Add a new venue"
      fill_in "Postcode", with: "invalid"

      click_button "Submit for review"

      expect(page).to have_text "can't be blank"
      expect(page).to have_text "is not included in the list"
      expect(page).to have_text "is invalid"
    end

    scenario "There are validation errors on building only" do
      allow_any_instance_of(GetIntoTeachingApiClient::TeachingEventsApi).to \
        receive(:upsert_teaching_event) { [] }

      navigate_to_new_submission

      enter_valid_event_details

      choose "Add a new venue"
      fill_in "Venue", with: "valid"
      fill_in "Postcode", with: "invalid"

      click_button "Submit for review"

      expect(page).to_not have_text "can't be blank"
      expect(page).to_not have_text "is not included in the list"
      expect(page).to have_text "is invalid"
    end

    scenario "There are validation errors on event only" do
      allow_any_instance_of(GetIntoTeachingApiClient::TeachingEventsApi).to \
        receive(:upsert_teaching_event) { [] }

      navigate_to_new_submission

      choose "Add a new venue"
      fill_in "Venue", with: "valid"
      fill_in "Postcode", with: "M1 7AX"

      click_button "Submit for review"

      expect(page).to have_text "can't be blank"
      expect(page).to have_text "is not included in the list"
      expect(page).to_not have_text "is invalid"
    end
  end

private

  def navigate_to_new_submission
    visit internal_events_path
    expect(page).to have_text "Pending Provider Events"

    click_button "Submit a provider event for review"
    expect(page).to have_text("Provider Event Details")
    expect(page).to have_checked_field("Search existing venues")
  end

  def navigate_to_edit_form
    visit internal_events_path
    expect(page).to have_text "Pending Provider Events"

    click_link "Event 1"
    expect(page).to have_text("This is a pending event")

    click_button "Edit this provider event"
    expect(page).to have_text("Provider Event Details")
  end

  def enter_valid_event_details
    fill_in "Event name", with: "test"
    fill_in "External event name", with: "test"
    fill_in "Event summary", with: "test"
    find(:id, "internal_event_description", visible: false)
      .click
      .set "some value here"
    fill_in "Provider email address", with: "test@test.com"
    fill_in "Provider organiser", with: "test"
    fill_in "Target audience", with: "test"
    fill_in "Provider website/registration link", with: "test"
    choose "Yes"
    fill_in "internal_event[start_at]", with: Time.zone.now + 1.day
    fill_in "internal_event[end_at]", with: Time.zone.now + 2.days
    choose "No venue"
  end
end
