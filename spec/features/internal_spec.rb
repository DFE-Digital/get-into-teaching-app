require "rails_helper"
require "action_text/system_test_helper"

RSpec.feature "Internal section", type: :feature do
  let(:types) { Events::Search.available_event_type_ids }
  let(:provider_event) do
    build(:event_api,
          :with_provider_info,
          name: "Pending provider event",
          readable_id: "Readable_id",
          status_id: GetIntoTeachingApiClient::Constants::EVENT_STATUS["Pending"],
          type_id: GetIntoTeachingApiClient::Constants::EVENT_TYPES["School or University event"])
  end
  let(:online_event) do
    build(:event_api,
          :with_provider_info,
          name: "Pending online event",
          readable_id: "Readable_id",
          status_id: GetIntoTeachingApiClient::Constants::EVENT_STATUS["Pending"],
          type_id: GetIntoTeachingApiClient::Constants::EVENT_TYPES["Online event"])
  end
  let(:provider_events_by_type) { group_events_by_type([provider_event]) }
  let(:online_events_by_type) { group_events_by_type([online_event]) }
  let(:publisher_username) { "publisher_username" }
  let(:publisher_password) { "publisher_password" }

  before do
    BasicAuth.class_variable_set(:@@credentials, nil)

    allow(Rails.application.config.x).to receive(:http_auth) do
      "#{publisher_username}|#{publisher_password}|publisher"
    end

    if page.driver.browser.respond_to?(:authorize)
      page.driver.browser.authorize(publisher_username, publisher_password)
    end

    allow_any_instance_of(GetIntoTeachingApiClient::TeachingEventBuildingsApi).to \
      receive(:get_teaching_event_buildings) { [] }

    allow_any_instance_of(GetIntoTeachingApiClient::TeachingEventsApi).to \
      receive(:upsert_teaching_event) { [] }

    allow_any_instance_of(GetIntoTeachingApiClient::TeachingEventsApi).to \
      receive(:get_teaching_event) { provider_event }

    allow_any_instance_of(GetIntoTeachingApiClient::TeachingEventsApi).to \
      receive(:search_teaching_events_grouped_by_type) { provider_events_by_type }
  end

  shared_examples "pending events" do |event_type|
    scenario "submit a new form" do
      navigate_to_new_submission(event_type)

      enter_valid_provider_event_details if event_type == "provider"
      enter_valid_online_event_details if event_type == "online"

      click_button "Submit for review"
      expect(page).to have_text "Event submitted for review"
      expect(page).to have_text "Pending event"
      expect(page).to have_link("test", href: internal_event_path("test"))
    end

    scenario "final submit" do
      visit internal_events_path(event_type: event_type)
      expect(page).to have_text "Pending #{event_type} events"

      click_link "Pending #{event_type} event"
      expect(page).to have_text("This is a pending event")

      click_button "Set event status to Open"
      expect(page).to have_text("Event published")
      expect(page).to have_text("Published event")
      expect(page).to have_link("Readable_id", href: event_path("Readable_id"))
    end
  end

  context "when provider event type" do
    include_examples "pending events", "provider" do
      before do
        allow_any_instance_of(GetIntoTeachingApiClient::TeachingEventsApi).to \
          receive(:search_teaching_events_grouped_by_type) { provider_events_by_type }
      end
    end

    scenario "edit a pending event with no building" do
      provider_event.building = nil

      navigate_to_edit_form

      expect(page).to have_checked_field("No venue")

      click_button "Submit for review"
      expect(page).to have_text "Event submitted for review"
    end

    scenario "edit a pending event with building" do
      navigate_to_edit_form

      expect(page).to have_checked_field("Search existing venues")
    end

    context "when the event submission is invalid" do
      scenario "there are validation errors on event and building" do
        navigate_to_new_submission("provider")

        enter_bad_start_end_dates

        choose "Add a new venue"
        fill_in "Postcode", with: "invalid"

        click_button "Submit for review"

        expect_provider_validation_errors
      end

      scenario "there are validation errors on building only" do
        navigate_to_new_submission("provider")

        enter_valid_provider_event_details

        choose "Add a new venue"

        click_button "Submit for review"

        expect_building_validation_errors
      end

      scenario "there are validation errors on event only" do
        navigate_to_new_submission("provider")

        enter_bad_start_end_dates

        choose "Add a new venue"
        fill_in "Venue", with: "valid"
        fill_in "Postcode", with: "M1 7AX"

        click_button "Submit for review"

        expect_provider_validation_errors
      end
    end
  end

  context "when online event type" do
    include_examples "pending events", "online" do
      before do
        allow_any_instance_of(GetIntoTeachingApiClient::TeachingEventsApi).to \
          receive(:search_teaching_events_grouped_by_type) { online_events_by_type }
      end
    end

    context "when the event submission is invalid" do
      scenario "there are validation errors on event" do
        navigate_to_new_submission("online")

        enter_bad_start_end_dates

        click_button "Submit for review"

        expect_online_validation_errors
      end
    end
  end

private

  def enter_bad_start_end_dates
    fill_in "internal_event[start_at]", with: 1.day.ago
    fill_in "internal_event[end_at]", with: 1.day.ago
  end

  def expect_building_validation_errors
    expect(page).to have_text "Enter a venue name"
    expect(page).to have_text "Enter a postcode"
  end

  def expect_online_validation_errors
    expect_common_validation_errors

    expect(page).to have_text "Enter a Scribble ID"
  end

  def expect_provider_validation_errors
    expect_common_validation_errors

    expect(page).to have_text "Choose whether the event is online"
    expect(page).to have_text "Enter a provider email address"
    expect(page).to have_text "Enter a provider organiser"
    expect(page).to have_text "Enter a provider target audience"
    expect(page).to have_text "Enter a provider website/registration link"
  end

  def expect_common_validation_errors
    expect(page).to have_text "Enter a name"
    expect(page).to have_text "Enter a summary"
    expect(page).to have_text "Enter a description"
    expect(page).to have_text "Enter a partial URL"
    # start_at and end_at in error summary and field message
    expect(page).to have_text "Must be in the future", count: 4
  end

  def navigate_to_new_submission(event_type)
    visit internal_events_path(event_type: event_type)
    expect(page).to have_text "Pending #{event_type} events"

    click_button "Submit #{event_type} event for review"

    expect(page).to have_text("#{event_type.capitalize} event details")

    expect(page).to have_checked_field("Search existing venues") if event_type == "provider"
  end

  def navigate_to_edit_form
    visit internal_events_path(event_type: "provider")
    expect(page).to have_text "Pending provider events"

    click_link "Pending provider event"
    expect(page).to have_text("This is a pending event")

    click_button "Edit this event"
    expect(page).to have_text("Provider event details")
  end

  def enter_valid_provider_event_details
    enter_common_event_details

    fill_in "Provider email address", with: "test@test.com"
    fill_in "Provider organiser", with: "test"
    fill_in "Target audience", with: "test"
    fill_in "Provider website/registration link", with: "test"
    choose "Yes"
    choose "No venue"
  end

  def enter_valid_online_event_details
    enter_common_event_details

    fill_in "Scribble ID", with: "test"
  end

  def enter_common_event_details
    fill_in "Event name", with: "test"
    fill_in "Event partial URL", with: "test"
    fill_in "Event summary", with: "test"
    find(:id, "internal_event_description", visible: false)
      .click
      .set "test"
    fill_in "internal_event[start_at]", with: Time.zone.now + 1.day
    fill_in "internal_event[end_at]", with: Time.zone.now + 2.days
  end
end
