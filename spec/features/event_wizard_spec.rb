require "rails_helper"

RSpec.feature "Event wizard", type: :feature do
  let(:git_api_endpoint) { ENV["GIT_API_ENDPOINT"] }
  let(:event_readable_id) { "123" }
  let(:event_name) { "Event Name" }
  let(:event) { build(:event_api, readable_id: event_readable_id, name: event_name) }
  let(:individual_event_page_title) { "Sign up for #{event.name}, personal details step | Get Into Teaching" }
  let(:sign_up_complete_page_title) { "#{event.name}, sign up completed | Get Into Teaching" }
  let(:event_accessibility_options) { build_list(:accessibility_option_api, 3) }

  before do
    allow_any_instance_of(GetIntoTeachingApiClient::TeachingEventsApi).to \
      receive(:get_teaching_event).with(event_readable_id).and_return(event)
    allow_any_instance_of(GetIntoTeachingApiClient::PickListItemsApi).to \
      receive(:get_teaching_event_types).and_return([])
    allow_any_instance_of(GetIntoTeachingApiClient::PickListItemsApi).to \
      receive(:get_teaching_event_accessibilty).and_return(event_accessibility_options)
  end

  scenario "Full journey as a walk-in candidate (closed event), no accessibility needs" do
    event.status_id = Crm::EventStatus.closed_id

    allow_any_instance_of(GetIntoTeachingApiClient::CandidatesApi).to \
      receive(:create_candidate_access_token).and_raise(GetIntoTeachingApiClient::ApiError)

    visit event_steps_path(event_id: event_readable_id, walk_in: true)

    expect(page).to have_title(individual_event_page_title)
    expect(page).to have_css("h1", text: "Sign up for this event")
    expect(page).to have_text event_name
    expect(page).to have_css(".registration-with-image-above")

    fill_in_personal_details_step
    click_on "Next step"

    expect(page).to have_text "Do you need any extra support to attend this event?"
    choose "No"
    click_on "Next step"

    fill_in "What's your telephone number? (optional)", with: "01234567890"

    expect_sign_up_with_attributes(base_attributes.merge({ is_walk_in: true }))

    click_on "Complete sign up"

    expect(page).to have_title(sign_up_complete_page_title)
  end

  scenario "Full journey as a walk-in candidate, skipping verification, with accessibility needs" do
    allow_any_instance_of(GetIntoTeachingApiClient::CandidatesApi).to \
      receive(:create_candidate_access_token)

    response = GetIntoTeachingApiClient::TeachingEventAddAttendee.new(
      event_id: event.id,
      is_verified: false,
    )
    allow_any_instance_of(GetIntoTeachingApiClient::TeachingEventsApi).to \
      receive(:exchange_unverified_request_for_teaching_event_add_attendee).with(anything) { response }

    visit event_steps_path(event_id: event_readable_id, walk_in: true)

    fill_in_personal_details_step
    click_on "Next step"

    expect(page).to have_text "To verify your details, we've sent a code to your email address."
    click_on "continue without verifying your identity"

    expect(page).to have_text "Do you need any extra support to attend this event?"
    choose "Yes"
    click_on "Next step"

    fill_in "Tell us about the extra support you need", with: "This is some test accessibility needs text"
    click_on "Next step"

    fill_in "What's your telephone number? (optional)", with: "01234567890"

    expect_sign_up_with_attributes(base_attributes.merge({ is_walk_in: true, is_verified: false }))

    click_on "Complete sign up"

    expect(page).to have_title(sign_up_complete_page_title)
  end

  scenario "Full journey as a new candidate, no accessibility needs" do
    allow_any_instance_of(GetIntoTeachingApiClient::CandidatesApi).to \
      receive(:create_candidate_access_token).and_raise(GetIntoTeachingApiClient::ApiError)

    visit event_steps_path(event_id: event_readable_id)

    expect(page).to have_title(individual_event_page_title)
    expect(page).to have_css("h1", text: "Sign up for this event")
    expect(page).to have_text event_name
    expect(page).to have_css(".registration-with-image-above")

    fill_in_personal_details_step
    click_on "Next step"

    expect(page).to have_text "Do you need any extra support to attend this event?"
    choose "No"
    click_on "Next step"

    fill_in "What's your telephone number? (optional)", with: "01234567890"
    expect_sign_up_with_attributes(base_attributes)
    click_on "Complete sign up"

    expect(page).to have_title(sign_up_complete_page_title)
    expect(page).to have_text "Get tailored email guidance"
  end

  scenario "Full journey as an existing candidate does not show link to the mailing list, with accessibility needs" do
    allow_any_instance_of(GetIntoTeachingApiClient::CandidatesApi).to \
      receive(:create_candidate_access_token)

    response = GetIntoTeachingApiClient::TeachingEventAddAttendee.new(
      event_id: event.id,
      address_postcode: "TE57 1NG",
      address_telephone: "9876543210",
    )
    allow_any_instance_of(GetIntoTeachingApiClient::TeachingEventsApi).to \
      receive(:exchange_access_token_for_teaching_event_add_attendee).with("123456", anything).and_return(response)

    visit event_steps_path(event_id: event_readable_id)

    expect(page).to have_css("h1", text: "Sign up for this event")
    expect(page).to have_css(".registration-with-image-above")

    fill_in_personal_details_step
    click_on "Next step"

    expect(page).to have_text "To verify your details, we've sent a code to your email address."
    fill_in "Enter your verification code:", with: "123456"
    expect_sign_up_with_attributes(base_attributes.merge(address_telephone: response.address_telephone))
    click_on "Next step"

    expect(page).to have_text "Do you need any extra support to attend this event?"
    choose "Yes"
    click_on "Next step"

    fill_in "Tell us about the extra support you need", with: "This is some test accessibility needs text"
    click_on "Complete sign up"

    expect(page).to have_title(sign_up_complete_page_title)

    # existing candidates in the CRM do not get a link to the mailing list
    expect(page).not_to have_text "Get tailored email guidance"
    expect(page).to have_text "Education is the most powerful tool you can use to change the world"
  end

  scenario "Full journey as a returning candidate that resends the verification code, no accessibility needs" do
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

    expect(page).to have_text "To verify your details, we've sent a code to your email address."
    fill_in "Enter your verification code:", with: "654321"
    click_on "Next step"

    expect(page).to have_text "Please enter the latest verification code"

    click_link "Send another code to verify my details"
    expect(page).to have_text "We've sent you another email"

    fill_in "Enter your verification code:", with: "123456"
    click_on "Next step"

    expect(page).to have_text "Do you need any extra support to attend this event?"
    choose "No"
    click_on "Next step"

    expect(page).to have_text("What's your telephone number? (optional)")
  end

  scenario "Full journey as an existing candidate that has already subscribed to the mailing list, with accessibility needs" do
    allow_any_instance_of(GetIntoTeachingApiClient::CandidatesApi).to \
      receive(:create_candidate_access_token)

    response = GetIntoTeachingApiClient::TeachingEventAddAttendee.new(
      event_id: event.id,
      address_telephone: nil,
      already_subscribed_to_mailing_list: true,
    )
    allow_any_instance_of(GetIntoTeachingApiClient::TeachingEventsApi).to \
      receive(:exchange_access_token_for_teaching_event_add_attendee).with("123456", anything).and_return(response)

    visit event_steps_path(event_id: event_readable_id)

    expect(page).to have_css("h1", text: "Sign up for this event")
    fill_in_personal_details_step
    click_on "Next step"

    expect(page).to have_text "To verify your details, we've sent a code to your email address."
    fill_in "Enter your verification code:", with: "123456"
    click_on "Next step"

    expect(page).to have_text "Do you need any extra support to attend this event?"
    choose "Yes"
    click_on "Next step"

    fill_in "Tell us about the extra support you need", with: "This is some test accessibility needs text"
    click_on "Next step"

    expect(page).to have_text("What's your telephone number? (optional)")

    expect_sign_up_with_attributes(base_attributes.merge({ address_telephone: nil }))

    click_on "Complete sign up"
    expect(page).not_to have_text "Get tailored email guidance"
    expect(page).to have_text "Education is the most powerful tool you can use to change the world"
  end

  scenario "Full journey as an existing candidate that has already subscribed to the teacher training adviser service, no accessibility needs" do
    allow_any_instance_of(GetIntoTeachingApiClient::CandidatesApi).to \
      receive(:create_candidate_access_token)

    response = GetIntoTeachingApiClient::TeachingEventAddAttendee.new(
      event_id: event.id,
      address_telephone: "0123456789",
      already_subscribed_to_teacher_training_adviser: true,
    )
    allow_any_instance_of(GetIntoTeachingApiClient::TeachingEventsApi).to \
      receive(:exchange_access_token_for_teaching_event_add_attendee).with("123456", anything).and_return(response)

    visit event_steps_path(event_id: event_readable_id)

    expect(page).to have_css("h1", text: "Sign up for this event")
    fill_in_personal_details_step
    click_on "Next step"

    expect(page).to have_text "To verify your details, we've sent a code to your email address."
    fill_in "Enter your verification code:", with: "123456"
    expect_sign_up_with_attributes(base_attributes.merge(address_telephone: response.address_telephone))
    click_on "Next step"

    expect(page).to have_text "Do you need any extra support to attend this event?"
    choose "Yes"
    click_on "Next step"

    fill_in "Tell us about the extra support you need", with: "This is some test accessibility needs text"
    click_on "Complete sign up"

    expect(page).to have_title(sign_up_complete_page_title)
    expect(page).not_to have_text "Get tailored email guidance"
    expect(page).to have_text "Education is the most powerful tool you can use to change the world"
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

  def expect_sign_up_with_attributes(request_attributes)
    allow_any_instance_of(GetIntoTeachingApiClient::TeachingEventsApi).to \
      receive(:add_teaching_event_attendee)
      .with(having_attributes(request_attributes))
  end
end
