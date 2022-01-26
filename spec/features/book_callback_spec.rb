require "rails_helper"

RSpec.feature "Book a callback", type: :feature do
  include_context "with wizard data"

  let(:quota) do
    GetIntoTeachingApiClient::CallbackBookingQuota.new(
      start_at: Time.zone.local(2099, 6, 1, 10),
      end_at: Time.zone.local(2099, 6, 1, 11),
    )
  end

  let(:callback_page_title) { "Callback confirmed | Get Into Teaching" }

  before do
    allow_any_instance_of(GetIntoTeachingApiClient::CallbackBookingQuotasApi).to \
      receive(:get_callback_booking_quotas) { [quota] }

    callback_attrs = {
      first_name: "John",
      last_name: "Doe",
      email: "email@address.com",
      address_telephone: "123456789",
      phone_call_scheduled_at: "#{quota.start_at.strftime('%Y-%m-%dT%H:%M:%S')}.000Z",
      accepted_policy_id: "123",
      talking_points: "Routes into teaching",
    }
    allow_any_instance_of(GetIntoTeachingApiClient::GetIntoTeachingApi).to \
      receive(:book_get_into_teaching_callback)
      .with(having_attributes(callback_attrs))
  end

  scenario "Full journey as an existing candidate" do
    allow_any_instance_of(GetIntoTeachingApiClient::CandidatesApi).to \
      receive(:create_candidate_access_token)

    response = GetIntoTeachingApiClient::GetIntoTeachingCallback.new(address_telephone: "123456789")
    allow_any_instance_of(GetIntoTeachingApiClient::GetIntoTeachingApi).to \
      receive(:exchange_access_token_for_get_into_teaching_callback).with("123456", anything) { response }

    visit callbacks_steps_path

    expect(page).to have_text "Book a callback"
    fill_in_personal_details_step
    click_on "Next step"

    expect(page).to have_text "You're already registered with us"
    fill_in "To verify your details, we've sent a code to your email address.", with: "123456"
    click_on "Next step"

    expect(page).to have_text "Choose a time for your callback"
    expect(find_field("Phone number").value).to eq(response.address_telephone)
    # Select time in local time zone (London)
    select "11:00am to 12:00pm", from: "Select your preferred day and time for a callback"
    click_on "Next step"

    expect(page).to have_text "Tell us what you’d like to talk to us about"
    select "Routes into teaching", from: "Choose an option"
    click_on "Next step"

    expect(page).to have_text "Accept privacy policy"
    check "Yes"
    click_on "Book your callback"

    expect(page).to have_title(callback_page_title)
    expect(page).to have_text "Callback confirmed"

    start_at = quota.start_at.in_time_zone("London")
    date = start_at.to_date.to_formatted_s(:govuk)
    time = start_at.to_formatted_s(:govuk_time_with_period)
    expect(page).to have_text "call you within 30 minutes of #{date} at #{time}"
  end

  scenario "Journey encountering errors" do
    allow_any_instance_of(GetIntoTeachingApiClient::CandidatesApi).to \
      receive(:create_candidate_access_token)

    allow_any_instance_of(GetIntoTeachingApiClient::GetIntoTeachingApi).to \
      receive(:exchange_access_token_for_get_into_teaching_callback).with("654321", anything).and_raise(GetIntoTeachingApiClient::ApiError)
    allow_any_instance_of(GetIntoTeachingApiClient::GetIntoTeachingApi).to \
      receive(:exchange_access_token_for_get_into_teaching_callback).with("123456", anything) do
      GetIntoTeachingApiClient::GetIntoTeachingCallback.new
    end

    visit callbacks_steps_path

    expect(page).to have_text "Book a callback"

    click_on "Next step"
    expect(page).to have_text "There is a problem"
    expect(page).to have_text "Enter your first name"
    expect(page).to have_text "Enter your last name"
    expect(page).to have_text "Enter your full email address"
    fill_in_personal_details_step
    click_on "Next step"

    expect(page).to have_text "You're already registered with us"
    fill_in "To verify your details, we've sent a code to your email address.", with: "654321"
    click_on "Next step"

    expect(page).to have_text "Please enter the latest verification code"

    click_link "Send another code to verify my details."
    expect(page).to have_text "We've sent you another email"

    fill_in "To verify your details, we've sent a code to your email address.", with: "123456"
    click_on "Next step"

    expect(page).to have_text "Choose a time for your callback"
    click_on "Next step"
    expect(page).to have_text "Enter your telephone number"
    fill_in "Phone number", with: "12"
    click_on "Next step"
    expect(page).to have_text "Enter a valid phone number"
    fill_in "Phone number", with: "123456789"
    # Select time in local time zone (London)
    select "11:00am to 12:00pm", from: "Select your preferred day and time for a callback"
    click_on "Next step"

    expect(page).to have_text "Tell us what you’d like to talk to us about"
    click_on "Next step"
    expect(page).to have_text "Choose an option"
    select "Routes into teaching", from: "Choose an option"
    click_on "Next step"

    expect(page).to have_text "Accept privacy policy"
    click_on "Book your callback"
    expect(page).to have_text "Accept the privacy policy to continue"
    check "Yes"
    click_on "Book your callback"

    expect(page).to have_title(callback_page_title)
    expect(page).to have_text "Callback confirmed"

    start_at = quota.start_at.in_time_zone("London")
    date = start_at.to_date.to_formatted_s(:govuk)
    time = start_at.to_formatted_s(:govuk_time_with_period)
    expect(page).to have_text "call you within 30 minutes of #{date} at #{time}"
  end

  scenario "Journey when candidate has issues signing in" do
    allow_any_instance_of(GetIntoTeachingApiClient::CandidatesApi).to \
      receive(:create_candidate_access_token).and_raise(GetIntoTeachingApiClient::ApiError.new(code: 404))

    visit callbacks_steps_path

    expect(page).to have_title("Book a callback, personal details step | Get Into Teaching")

    expect(page).to have_text "Book a callback"
    fill_in_personal_details_step
    click_on "Next step"

    expect(page).to have_text "We didn’t recognise the first name, last name or email address you entered"

    click_link "Try entering your details again"
    click_on "Next step"

    expect(page).to have_text "We didn’t recognise the first name, last name or email address you entered"
    expect(page).to have_text "Try entering your details again"

    click_link "Try entering your details again"
    click_on "Next step"

    expect(page).to have_text "We didn’t recognise your first name, last name or email address"
    expect(page).to have_text "Once you’re registered, you can try again"

    allow_any_instance_of(GetIntoTeachingApiClient::CandidatesApi).to \
      receive(:create_candidate_access_token).and_raise(GetIntoTeachingApiClient::ApiError.new(code: 500))

    visit callbacks_steps_path
    click_on "Next step"

    expect(page).to have_text "Sorry, a technical problem means we can’t book your callback right now."
  end

  def fill_in_personal_details_step(
    first_name: "John",
    last_name: "Doe",
    email: "email@address.com"
  )
    fill_in "First name", with: first_name if first_name
    fill_in "Last name", with: last_name if last_name
    fill_in "Email address", with: email if email
  end
end
