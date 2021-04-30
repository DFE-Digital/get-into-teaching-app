require "rails_helper"

RSpec.feature "Mailing list signup", type: :feature do
  include_context "stub types api"
  include_context "stub candidate create access token api"
  include_context "stub latest privacy policy api"
  include_context "stub mailing list add member api"

  let(:privacy_policy_id) { "PP-ABC-123" }

  before do
    allow_any_instance_of(GetIntoTeachingApiClient::PrivacyPoliciesApi).to receive(:get_latest_privacy_policy).and_return(OpenStruct.new(id: privacy_policy_id))
  end

  def enter_candidate_details
    fill_in "First name", with: "Milhouse"
    fill_in "Last name", with: "van Houten"
    fill_in "Email address", with: "mvh@hotmail.com"
    select "It’s just an idea", from: "How close are you to applying for teacher training?"
    select "Graduate or postgraduate", from: "Do you have a degree?"
    select "Maths", from: "What would you like to teach?"
    check "I am over 16 years old and accept the terms and conditions"
  end

  def enter_invalid_candidate_details
    fill_in "First name", with: ""
    fill_in "Last name", with: ""
  end

  def check_registration_form
    [
      "First name",
      "Last name",
      "Email address",
      "How close are you to applying for teacher training?",
      "Do you have a degree?",
      "What's your postcode? (optional)",
      "What would you like to teach?",
      "I am over 16 years old and accept the terms and conditions",
    ].each do |field_name|
      expect(page).to have_field(field_name)
    end

    expect(page.find("#mailing_list_signup_accepted_policy_id", visible: false).value).to eql(privacy_policy_id)
  end

  def check_verification_form
    expect(page).to have_current_path(edit_mailing_list_signup_path)
    expect(page).to have_field("Verification code")
    expect(page).to have_css(".button", text: "Verify")
  end

  context "when the user doesn't exist in the CRM" do
    before do
      allow_any_instance_of(MailingList::Signup).to(receive(:already_signed_up?).and_return(false))
    end

    specify "registering as a new user" do
      visit new_mailing_list_signup_path

      check_registration_form

      # first incorrectly
      enter_invalid_candidate_details
      click_on "Register"
      expect(page).to have_text("Enter your first name")
      expect(page).to have_text("Enter your last name")

      # now correctly
      enter_candidate_details
      click_on "Register"

      expect(page).to have_current_path(completed_mailing_list_steps_path)
    end
  end

  context "when the user exists in the CRM" do
    before do
      allow_any_instance_of(GetIntoTeachingApiClient::MailingListApi).to(
        receive(:exchange_access_token_for_mailing_list_add_member).with("123456", anything) do
          GetIntoTeachingApiClient::MailingListAddMember.new
        end,
      )
    end

    specify "registering and confirming identity using a verification code" do
      visit new_mailing_list_signup_path

      check_registration_form

      # first incorrectly
      enter_invalid_candidate_details
      click_on "Register"
      expect(page).to have_text("Enter your first name")
      expect(page).to have_text("Enter your last name")

      # now correctly
      enter_candidate_details
      click_on "Register"

      fill_in "Verification code", with: "123456"

      click_on "Verify"

      expect(page).to have_current_path(completed_mailing_list_steps_path)
    end
  end

  context "when the user is already on the mailing list" do
    before do
      allow_any_instance_of(GetIntoTeachingApiClient::MailingListApi).to(
        receive(:exchange_access_token_for_mailing_list_add_member).with("123456", anything) do
          GetIntoTeachingApiClient::MailingListAddMember.new
        end,
      )

      allow_any_instance_of(GetIntoTeachingApiClient::MailingListApi).to(
        receive(:exchange_access_token_for_mailing_list_add_member).with("234567", anything) do
          raise GetIntoTeachingApiClient::ApiError
        end,
      )

      allow_any_instance_of(MailingList::Signup).to receive(:already_subscribed_to_mailing_list).and_return(true)
    end

    specify "registering and confirming identity using a verification code" do
      visit new_mailing_list_signup_path

      check_registration_form
      enter_candidate_details
      click_on "Register"

      check_verification_form

      # first do it incorrectly
      fill_in "Verification code", with: "234567"
      click_on "Verify"
      expect(page).to have_content("Enter the code you received by email")

      # now correctly
      fill_in "Verification code", with: "123456"
      click_on "Verify"

      expect(page).to have_current_path(mailing_list_step_path("already_subscribed"))
    end
  end
end
