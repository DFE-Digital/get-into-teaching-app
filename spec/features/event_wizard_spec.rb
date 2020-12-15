require "rails_helper"

RSpec.feature "Event wizard", type: :feature do
  include_context "stub types api"

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
    allow_any_instance_of(GetIntoTeachingApiClient::PickListItemsApi).to \
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

    within_fieldset "Would you like to receive email updates" do
      choose "Yes"
    end
    click_on "Complete sign up"

    expect(page).to have_text "There is a problem"
    expect(page).to have_text "Accept the privacy policy to continue"
    within_fieldset "Are you over 16 and do you agree" do
      check "Yes"
    end

    click_on "Complete sign up"

    fill_in_personalised_updates
    click_on "Complete sign up"

    expect(page).to have_text "What happens next"
    expect(page).to have_text "signed up for email updates"
  end

  scenario "Full journey as a new candidate declining the mailing list option" do
    allow_any_instance_of(GetIntoTeachingApiClient::CandidatesApi).to \
      receive(:create_candidate_access_token).and_raise(GetIntoTeachingApiClient::ApiError)

    visit event_steps_path(event_id: event_readable_id)

    expect(page).to have_text "Sign up for this event"
    expect(page).to have_text event_name
    fill_in_personal_details_step
    click_on "Next Step"

    fill_in "Phone number (optional)", with: "01234567890"
    click_on "Next Step"

    within_fieldset "Would you like to receive email updates" do
      choose "No"
    end
    click_on "Complete sign up"

    expect(page).to have_text "There is a problem"
    expect(page).to have_text "Accept the privacy policy to continue"
    within_fieldset "Are you over 16 and do you agree" do
      check "Yes"
    end
    click_on "Complete sign up"

    expect(page).to have_text "What happens next"
    expect(page).not_to have_text "signed up for email updates"
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

    expect(page).to have_text "Are you over 16 and do you agree"
    expect(page).to have_text "Would you like to receive email updates"
    click_on "Complete sign up"

    expect(page).to have_text "There is a problem"
    expect(page).to have_text "Accept the privacy policy to continue"
    expect(page).to have_text "Choose yes or no"

    within_fieldset "Are you over 16 and do you agree" do
      check "Yes"
    end
    within_fieldset "Would you like to receive email updates" do
      choose "Yes"
    end
    click_on "Complete sign up"

    fill_in_personalised_updates
    click_on "Complete sign up"

    expect(page).to have_text "What happens next"
    expect(page).to have_text "signed up for email updates"
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

  scenario "Full journey as an existing candidate that has already subscribed to the mailing list" do
    allow_any_instance_of(GetIntoTeachingApiClient::CandidatesApi).to \
      receive(:create_candidate_access_token)

    response = GetIntoTeachingApiClient::TeachingEventAddAttendee.new(
      eventId: "abc-123",
      alreadySubscribedToMailingList: true,
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

    expect(page).to have_text("Are you over 16 and do you agree")
    expect(page).to_not have_text("Would you like to receive email updates")
    click_on "Complete sign up"

    expect(page).to have_text "There is a problem"
    expect(page).to have_text "Accept the privacy policy to continue"
    expect(page).to_not have_text "Choose yes or no"

    within_fieldset "Are you over 16 and do you agree" do
      check "Yes"
    end
    click_on "Complete sign up"

    expect(page).to have_text "What happens next"
    expect(page).not_to have_text "signed up for email updates"
  end

  scenario "Full journey as an existing candidate that has already subscribed to the teacher training adviser service" do
    allow_any_instance_of(GetIntoTeachingApiClient::CandidatesApi).to \
      receive(:create_candidate_access_token)

    response = GetIntoTeachingApiClient::TeachingEventAddAttendee.new(
      eventId: "abc-123",
      alreadySubscribedToTeacherTrainingAdviser: true,
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

    expect(page).to have_text("Are you over 16 and do you agree")
    expect(page).to_not have_text("Would you like to receive email updates")
    click_on "Complete sign up"

    expect(page).to have_text "There is a problem"
    expect(page).to have_text "Accept the privacy policy to continue"
    expect(page).to_not have_text "Choose yes or no"

    within_fieldset "Are you over 16 and do you agree" do
      check "Yes"
    end
    click_on "Complete sign up"

    expect(page).to have_text "What happens next"
    expect(page).not_to have_text "signed up for email updates"
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

  def fill_in_personalised_updates(
    degree_status: nil,
    consideration_journey_stage: nil,
    postcode: "TE57 1NG",
    preferred_teaching_subject: nil
  )
    select_value_or_default "What stage are you at with your degree?", degree_status
    select_value_or_default "How close are you to applying for teacher training?", consideration_journey_stage
    fill_in "What is your postcode? (optional)", with: postcode
    select_value_or_default "What subject do you want to teach?", preferred_teaching_subject
  end

  def select_value_or_default(label, value = nil)
    if value
      select(value, from: label)
    else
      # choosing second option because first is 'Please select'
      find_field(label).find("option:nth-of-type(2)").select_option
    end
  end
end
