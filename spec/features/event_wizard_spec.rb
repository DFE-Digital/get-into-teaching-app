require "rails_helper"

RSpec.feature "Event wizard", type: :feature do
  include_context "with stubbed types api"

  let(:git_api_endpoint) { ENV["GIT_API_ENDPOINT"] }
  let(:event_readable_id) { "123" }
  let(:event_name) { "Event Name" }
  let(:latest_privacy_policy) { GetIntoTeachingApiClient::PrivacyPolicy.new({ id: 123 }) }
  let(:event) { build(:event_api, readable_id: event_readable_id, name: event_name) }
  let(:individual_event_page_title) { "Sign up for #{event.name}, personal details step | Get Into Teaching" }
  let(:sign_up_complete_page_title) { "Sign up complete | Get Into Teaching" }

  before do
    allow_any_instance_of(GetIntoTeachingApiClient::TeachingEventsApi).to \
      receive(:get_teaching_event).with(event_readable_id).and_return(event)
    allow_any_instance_of(GetIntoTeachingApiClient::PrivacyPoliciesApi).to \
      receive(:get_latest_privacy_policy).and_return(latest_privacy_policy)
    allow_any_instance_of(GetIntoTeachingApiClient::PickListItemsApi).to \
      receive(:get_teaching_event_types).and_return([])
  end

  scenario "Full journey as a walk-in candidate (closed event)" do
    event.status_id = EventStatus.closed_id

    allow_any_instance_of(GetIntoTeachingApiClient::CandidatesApi).to \
      receive(:create_candidate_access_token).and_raise(GetIntoTeachingApiClient::ApiError)

    visit event_steps_path(event_id: event_readable_id, walk_in: true)

    expect(page).to have_title(individual_event_page_title)
    expect(page).to have_css("h1", text: "Sign up for this event")
    expect(page).to have_text event_name
    expect(page).to have_css(".registration-with-image-above")

    fill_in_personal_details_step
    click_on "Next step"

    fill_in "What is your telephone number? (optional)", with: "01234567890"
    click_on "Next step"

    within_fieldset "Would you like to receive email updates" do
      choose "No"
    end
    within_fieldset "Are you over 16 and do you agree" do
      check "Yes"
    end

    expect_sign_up_with_attributes(base_attributes.merge({ is_walk_in: true }))

    click_on "Complete sign up"

    expect(page).to have_title(sign_up_complete_page_title)
  end

  scenario "Full journey as a walk-in candidate, skipping verification" do
    allow_any_instance_of(GetIntoTeachingApiClient::CandidatesApi).to \
      receive(:create_candidate_access_token)

    response = GetIntoTeachingApiClient::TeachingEventAddAttendee.new(
      eventId: event.id,
      isVerified: false,
    )
    allow_any_instance_of(GetIntoTeachingApiClient::TeachingEventsApi).to \
      receive(:exchange_unverified_request_for_teaching_event_add_attendee).with(anything) { response }

    visit event_steps_path(event_id: event_readable_id, walk_in: true)

    fill_in_personal_details_step
    click_on "Next step"

    expect(page).to have_text "Check your email and enter the verification code sent to test@user.com"
    click_on "continue without verifying your identity"

    fill_in "What is your telephone number? (optional)", with: "01234567890"
    click_on "Next step"

    within_fieldset "Would you like to receive email updates" do
      choose "No"
    end
    within_fieldset "Are you over 16 and do you agree" do
      check "Yes"
    end

    expect_sign_up_with_attributes(base_attributes.merge({ is_walk_in: true, is_verified: false }))

    click_on "Complete sign up"

    expect(page).to have_title(sign_up_complete_page_title)
  end

  scenario "Full journey as a new candidate" do
    allow_any_instance_of(GetIntoTeachingApiClient::CandidatesApi).to \
      receive(:create_candidate_access_token).and_raise(GetIntoTeachingApiClient::ApiError)

    visit event_steps_path(event_id: event_readable_id)

    expect(page).to have_title(individual_event_page_title)
    expect(page).to have_css("h1", text: "Sign up for this event")
    expect(page).to have_text event_name
    expect(page).to have_css(".registration-with-image-above")

    fill_in_personal_details_step
    click_on "Next step"

    fill_in "What is your telephone number? (optional)", with: "01234567890"
    click_on "Next step"

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

    expect_sign_up_with_attributes(base_attributes.merge(personalised_attributes))

    click_on "Complete sign up"

    expect(page).to have_title(sign_up_complete_page_title)
    expect(page).to have_text "What happens next"
    expect(page).to have_text "signed up for email updates"
  end

  scenario "Full journey as a new candidate declining the mailing list option" do
    allow_any_instance_of(GetIntoTeachingApiClient::CandidatesApi).to \
      receive(:create_candidate_access_token).and_raise(GetIntoTeachingApiClient::ApiError)

    visit event_steps_path(event_id: event_readable_id)

    expect(page).to have_css("h1", text: "Sign up for this event")
    expect(page).to have_text event_name
    expect(page).to have_css(".registration-with-image-above")

    fill_in_personal_details_step
    click_on "Next step"

    fill_in "What is your telephone number? (optional)", with: "01234567890"
    click_on "Next step"

    within_fieldset "Would you like to receive email updates" do
      choose "No"
    end
    click_on "Complete sign up"

    expect(page).to have_text "There is a problem"
    expect(page).to have_text "Accept the privacy policy to continue"
    within_fieldset "Are you over 16 and do you agree" do
      check "Yes"
    end

    expect_sign_up_with_attributes(base_attributes)

    click_on "Complete sign up"

    expect(page).to have_text "What happens next"
    expect(page).not_to have_text "signed up for email updates"
  end

  scenario "Full journey as an existing candidate" do
    allow_any_instance_of(GetIntoTeachingApiClient::CandidatesApi).to \
      receive(:create_candidate_access_token)

    response = GetIntoTeachingApiClient::TeachingEventAddAttendee.new(
      eventId: event.id,
      addressPostcode: "TE57 1NG",
      addressTelephone: "1234567890",
    )
    allow_any_instance_of(GetIntoTeachingApiClient::TeachingEventsApi).to \
      receive(:exchange_access_token_for_teaching_event_add_attendee).with("123456", anything).and_return(response)

    visit event_steps_path(event_id: event_readable_id)

    expect(page).to have_css("h1", text: "Sign up for this event")
    expect(page).to have_css(".registration-with-image-above")

    fill_in_personal_details_step
    click_on "Next step"

    expect(page).to have_text "Check your email and enter the verification code sent to test@user.com"
    fill_in "Check your email and enter the verification code sent to test@user.com", with: "123456"
    click_on "Next step"

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

    expect(page).not_to have_text("What is your postcode? (optional)")
    fill_in_personalised_updates

    expect_sign_up_with_attributes(
      base_attributes
        .merge(personalised_attributes,
               {
                 address_telephone: response.address_telephone,
                 address_postcode: response.address_postcode,
               }),
    )

    click_on "Complete sign up"

    expect(page).to have_text "What happens next"
    expect(page).to have_text "signed up for email updates"
  end

  scenario "Full journey as a returning candidate that resends the verification code" do
    allow_any_instance_of(GetIntoTeachingApiClient::CandidatesApi).to \
      receive(:create_candidate_access_token)

    response = GetIntoTeachingApiClient::TeachingEventAddAttendee.new
    allow_any_instance_of(GetIntoTeachingApiClient::TeachingEventsApi).to \
      receive(:exchange_access_token_for_teaching_event_add_attendee).with("654321", anything).and_raise(GetIntoTeachingApiClient::ApiError)
    allow_any_instance_of(GetIntoTeachingApiClient::TeachingEventsApi).to \
      receive(:exchange_access_token_for_teaching_event_add_attendee).with("123456", anything).and_return(response)

    visit event_steps_path(event_id: event_readable_id)

    expect(page).to have_css("h1", text: "Sign up for this event")
    expect(page).to have_text event_name
    expect(page).to have_css(".registration-with-image-above")

    fill_in_personal_details_step
    click_on "Next step"

    expect(page).to have_text "Check your email and enter the verification code sent to test@user.com"
    fill_in "Check your email and enter the verification code sent to test@user.com", with: "654321"
    click_on "Next step"

    expect(page).to have_text "Please enter the latest verification code"

    click_link "resend verification"
    expect(page).to have_text "We've sent you another email."

    fill_in "Check your email and enter the verification code sent to test@user.com", with: "123456"
    click_on "Next step"

    expect(page).to have_text("What is your telephone number? (optional)")
  end

  scenario "Full journey as an existing candidate that has already subscribed to the mailing list" do
    allow_any_instance_of(GetIntoTeachingApiClient::CandidatesApi).to \
      receive(:create_candidate_access_token)

    response = GetIntoTeachingApiClient::TeachingEventAddAttendee.new(
      eventId: event.id,
      addressTelephone: nil,
      alreadySubscribedToMailingList: true,
    )
    allow_any_instance_of(GetIntoTeachingApiClient::TeachingEventsApi).to \
      receive(:exchange_access_token_for_teaching_event_add_attendee).with("123456", anything).and_return(response)

    visit event_steps_path(event_id: event_readable_id)

    expect(page).to have_css("h1", text: "Sign up for this event")
    fill_in_personal_details_step
    click_on "Next step"

    expect(page).to have_text "Check your email and enter the verification code sent to test@user.com"
    fill_in "Check your email and enter the verification code sent to test@user.com", with: "123456"
    click_on "Next step"

    expect(page).to have_text("What is your telephone number? (optional)")
    click_on "Next step"

    expect(page).to have_text("Are you over 16 and do you agree")
    expect(page).not_to have_text("Would you like to receive email updates")
    click_on "Complete sign up"

    expect(page).to have_text "There is a problem"
    expect(page).to have_text "Accept the privacy policy to continue"
    expect(page).not_to have_text "Choose yes or no"

    within_fieldset "Are you over 16 and do you agree" do
      check "Yes"
    end

    expect_sign_up_with_attributes(base_attributes.merge({ address_telephone: nil }))

    click_on "Complete sign up"

    expect(page).to have_text "What happens next"
    expect(page).not_to have_text "signed up for email updates"
  end

  scenario "Full journey as an existing candidate that has already subscribed to the teacher training adviser service" do
    allow_any_instance_of(GetIntoTeachingApiClient::CandidatesApi).to \
      receive(:create_candidate_access_token)

    response = GetIntoTeachingApiClient::TeachingEventAddAttendee.new(
      eventId: event.id,
      addressTelephone: nil,
      alreadySubscribedToTeacherTrainingAdviser: true,
    )
    allow_any_instance_of(GetIntoTeachingApiClient::TeachingEventsApi).to \
      receive(:exchange_access_token_for_teaching_event_add_attendee).with("123456", anything).and_return(response)

    visit event_steps_path(event_id: event_readable_id)

    expect(page).to have_css("h1", text: "Sign up for this event")
    fill_in_personal_details_step
    click_on "Next step"

    expect(page).to have_text "Check your email and enter the verification code sent to test@user.com"
    fill_in "Check your email and enter the verification code sent to test@user.com", with: "123456"
    click_on "Next step"

    expect(page).to have_text("What is your telephone number? (optional)")
    click_on "Next step"

    expect(page).to have_text("Are you over 16 and do you agree")
    expect(page).not_to have_text("Would you like to receive email updates")
    click_on "Complete sign up"

    expect(page).to have_text "There is a problem"
    expect(page).to have_text "Accept the privacy policy to continue"
    expect(page).not_to have_text "Choose yes or no"

    within_fieldset "Are you over 16 and do you agree" do
      check "Yes"
    end

    expect_sign_up_with_attributes(base_attributes.merge({ address_telephone: nil }))

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
    fill_in "Last name", with: last_name if last_name
    fill_in "Email address", with: email if email
  end

  def fill_in_personalised_updates(
    degree_status: nil,
    consideration_journey_stage: nil,
    postcode: "TE57 1NG",
    preferred_teaching_subject: nil
  )
    select_value_or_default "Do you have a degree?", degree_status
    select_value_or_default "How close are you to applying for teacher training?", consideration_journey_stage
    if page.has_text?("What is your postcode? (optional)")
      fill_in "What is your postcode? (optional)", with: postcode
    end
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

  def base_attributes
    {
      event_id: event.id,
      first_name: "Test",
      last_name: "User",
      email: "test@user.com",
      is_walk_in: false,
      address_telephone: "01234567890",
    }
  end

  def personalised_attributes
    {
      degree_status_id: 222_750_000,
      consideration_journey_stage_id: 222_750_000,
      address_postcode: "TE57 1NG",
      preferred_teaching_subject_id: "7e2655a1-2afa-e811-a981-000d3a276620",
    }
  end

  def expect_sign_up_with_attributes(request_attributes)
    allow_any_instance_of(GetIntoTeachingApiClient::TeachingEventsApi).to \
      receive(:add_teaching_event_attendee)
      .with(having_attributes(request_attributes))
  end
end
