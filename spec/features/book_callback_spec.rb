require "rails_helper"

RSpec.feature "Book a callback", type: :feature do
  include_context "with wizard data"

  let(:quota) do
    GetIntoTeachingApiClient::CallbackBookingQuota.new(
      start_at: Time.zone.local(2099, 6, 1, 10),
      end_at: Time.zone.local(2099, 6, 1, 11),
    )
  end

  let(:callback_attrs) do
    {
      first_name: "John",
      last_name: "Doe",
      email: "email@address.com",
      address_telephone: "123456789",
      phone_call_scheduled_at: "#{quota.start_at.strftime('%Y-%m-%dT%H:%M:%S')}.000Z",
      accepted_policy_id: "123",
      talking_points: "Routes into teaching",
    }
  end

  let(:callback_page_title) { "Callback confirmed | Get Into Teaching" }

  before do
    allow_any_instance_of(GetIntoTeachingApiClient::CallbackBookingQuotasApi).to \
      receive(:get_callback_booking_quotas) { [quota] }

    allow_any_instance_of(GetIntoTeachingApiClient::GetIntoTeachingApi).to \
      receive(:matchback_get_into_teaching_callback).with({ email: "email@address.com" }) do
      GetIntoTeachingApiClient::GetIntoTeachingCallback.new
    end

    allow_any_instance_of(GetIntoTeachingApiClient::GetIntoTeachingApi).to \
      receive(:book_get_into_teaching_callback)
      .with(having_attributes(callback_attrs))
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

    page.set_rack_session(mailinglist: callback_attrs.slice(:first_name, :last_name, :email, :accepted_policy_id))

    visit callbacks_steps_path

    expect(page).to have_text "Choose a time for your callback"
    click_on "Next step"

    expect(page).to have_text "Enter your telephone number"
    fill_in "Phone number", with: "abc123def"
    click_on "Next step"
    expect(page).to have_text "Enter your telephone number in the correct format"
    fill_in "Phone number", with: "123456789"
    # Select time in local time zone (London)
    select "11:00am to 12:00pm", from: "Select your preferred day and time for a callback"
    click_on "Next step"

    expect(page).to have_text "Tell us what you’d like to talk to us about"
    click_on "Book your callback"
    expect(page).to have_text "Choose an option"
    select "Routes into teaching", from: "Choose an option"
    click_on "Book your callback"

    expect(page).to have_title(callback_page_title)
    expect(page).to have_text "Callback confirmed"

    start_at = quota.start_at.in_time_zone("London")
    date = start_at.to_date.to_formatted_s(:govuk)
    time = start_at.to_formatted_s(:govuk_time_with_period)
    expect(page).to have_text "call you within 30 minutes of #{date} at #{time}"
  end

  context "when here are no callback slots available" do
    before do
      allow_any_instance_of(GetIntoTeachingApiClient::CallbackBookingQuotasApi).to \
        receive(:get_callback_booking_quotas).and_return([])
    end

    scenario "Viewing the callback page" do
      page.set_rack_session(mailinglist: callback_attrs.slice(:first_name, :last_name, :email, :accepted_policy_id))

      visit callbacks_step_path(:callback)

      expect(page).not_to have_text("Choose a time for your callback")
      expect(page).to have_text("We can't call you back at the moment")
      expect(page).to have_link("Call us on: 0800 389 2500")
    end
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
