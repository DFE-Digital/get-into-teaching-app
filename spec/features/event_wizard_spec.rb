require "rails_helper"

RSpec.feature "Event wizard", type: :feature do
  let(:git_api_endpoint) { ENV["GIT_API_ENDPOINT"] }
  let(:event_readable_id) { "123" }
  let(:event_name) { "Event Name" }
  let(:latest_privacy_policy) { GetIntoTeachingApiClient::PrivacyPolicy.new({ id: 123 }) }
  let(:event) { build(:event_api, readable_id: event_readable_id, name: event_name) }

  before do
    allow_any_instance_of(GetIntoTeachingApiClient::TeachingEventsApi).to \
      receive(:get_teaching_event).with(event_readable_id).and_return(event)
    allow_any_instance_of(GetIntoTeachingApiClient::PrivacyPoliciesApi).to \
      receive(:get_latest_privacy_policy).and_return(latest_privacy_policy)
    allow_any_instance_of(GetIntoTeachingApiClient::TeachingEventsApi).to \
      receive(:add_teaching_event_attendee)
    allow_any_instance_of(GetIntoTeachingApiClient::TypesApi).to \
      receive(:get_teaching_event_types) { [] }
  end

  scenario "Full journey as a new candidate" do
    allow_any_instance_of(GetIntoTeachingApiClient::CandidatesApi).to \
      receive(:create_candidate_access_token).and_raise(GetIntoTeachingApiClient::ApiError)

    visit event_steps_path(event_id: event_readable_id)

    expect(page).to have_text "Sign up for this event"
    expect(page).to have_text event_name
    fill_in_personal_details_step
    click_on "Next Step"

    fill_in "Phone number (optional)", with: "01234567890"
    click_on "Next Step"

    fill_in "Postcode (optional)", with: "TE57 1NG"
    click_on "Complete sign up"

    expect(page).to have_text "There is a problem"
    expect(page).to have_text "Accept the privacy policy to continue"
    expect(page).to have_text "Choose yes or no"
    check "Yes"
    choose "events-steps-further-details-future-events-field-error"
    choose "events-steps-further-details-mailing-list-field"
    click_on "Complete sign up"

    expect(page).to have_text "What happens next"
  end

  scenario "Full journey as an existing candidate" do
    allow_any_instance_of(GetIntoTeachingApiClient::CandidatesApi).to \
      receive(:create_candidate_access_token)

    response = GetIntoTeachingApiClient::TeachingEventAddAttendee.new(
      eventId: "abc-123",
      addressPostcode: "TE57 1NG",
      telephone: "1234567890",
    )
    allow_any_instance_of(GetIntoTeachingApiClient::TeachingEventsApi).to \
      receive(:get_pre_filled_teaching_event_add_attendee).with("123456", anything).and_return(response)

    visit event_steps_path(event_id: event_readable_id)

    expect(page).to have_text "Sign up for this event"
    expect(page).to have_text event_name
    fill_in_personal_details_step
    click_on "Next Step"

    expect(page).to have_text "Enter the verification code"
    fill_in "Enter the verification code sent to test@user.com", with: "123456"
    click_on "Next Step"

    expect(page).to have_field("Phone number (optional)", with: response.telephone)
    click_on "Next Step"

    expect(page).to have_field("Postcode (optional)", with: response.address_postcode)
    click_on "Complete sign up"

    expect(page).to have_text "There is a problem"
    expect(page).to have_text "Accept the privacy policy to continue"
    expect(page).to have_text "Choose yes or no"
    check "Yes"
    choose "events-steps-further-details-future-events-field"
    choose "events-steps-further-details-mailing-list-field-error"
    click_on "Complete sign up"

    expect(page).to have_text "What happens next"
  end

  scenario "Full journey as a returning candidate that resends the verification code" do
    allow_any_instance_of(GetIntoTeachingApiClient::CandidatesApi).to \
      receive(:create_candidate_access_token)

    response = GetIntoTeachingApiClient::TeachingEventAddAttendee.new
    allow_any_instance_of(GetIntoTeachingApiClient::TeachingEventsApi).to \
      receive(:get_pre_filled_teaching_event_add_attendee).with("654321", anything).and_raise(GetIntoTeachingApiClient::ApiError)
    allow_any_instance_of(GetIntoTeachingApiClient::TeachingEventsApi).to \
      receive(:get_pre_filled_teaching_event_add_attendee).with("123456", anything).and_return(response)

    visit event_steps_path(event_id: event_readable_id)

    expect(page).to have_text "Sign up for this event"
    expect(page).to have_text event_name
    fill_in_personal_details_step
    click_on "Next Step"

    expect(page).to have_text "Enter the verification code"
    fill_in "Enter the verification code sent to test@user.com", with: "654321"
    click_on "Next Step"

    expect(page).to have_text "Please enter the latest verification code"

    click_link "resend verification"
    expect(page).to have_text "We've sent you another email."

    fill_in "Enter the verification code sent to test@user.com", with: "123456"
    click_on "Next Step"

    expect(page).to have_text("Phone number (optional)")
  end

  scenario "Full journey as an existing candidate that has already subscribed" do
    allow_any_instance_of(GetIntoTeachingApiClient::CandidatesApi).to \
      receive(:create_candidate_access_token)

    response = GetIntoTeachingApiClient::TeachingEventAddAttendee.new(
      eventId: "abc-123",
      alreadySubscribedToMailingList: true,
      alreadySubscribedToEvents: true,
    )
    allow_any_instance_of(GetIntoTeachingApiClient::TeachingEventsApi).to \
      receive(:get_pre_filled_teaching_event_add_attendee).with("123456", anything).and_return(response)

    visit event_steps_path(event_id: event_readable_id)

    expect(page).to have_text "Sign up for this event"
    expect(page).to have_text event_name
    fill_in_personal_details_step
    click_on "Next Step"

    expect(page).to have_text "Enter the verification code"
    fill_in "Enter the verification code sent to test@user.com", with: "123456"
    click_on "Next Step"

    expect(page).to have_text("Phone number (optional)")
    click_on "Next Step"

    expect(page).to have_text("Postcode (optional)")
    expect(page).to_not have_text("Would you like to receive information about future events")
    expect(page).to_not have_text("Would you like to receive personalised information")
    click_on "Complete sign up"

    expect(page).to have_text "There is a problem"
    expect(page).to have_text "Accept the privacy policy to continue"
    expect(page).to_not have_text "Choose yes or no"
    check "Yes"
    click_on "Complete sign up"

    expect(page).to have_text "What happens next"
  end

  def fill_in_personal_details_step(
    first_name: "Test",
    last_name: "User",
    email: "test@user.com"
  )
    fill_in "First name", with: first_name if first_name
    fill_in "Surname", with: last_name if last_name
    fill_in "Email address", with: email if email
  end
end
