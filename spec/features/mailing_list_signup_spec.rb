require "rails_helper"

RSpec.feature "Mailing list signup", type: :feature do
  include_context "stub types api"
  include_context "stub candidate create access token api"
  include_context "stub latest privacy policy api"
  include_context "stub mailing list add member api"

  def enter_candidate_details
    fill_in "First name", with: "Milhouse"
    fill_in "Last name", with: "van Houten"
    fill_in "Email address", with: "mvh@hotmail.com"
    select "It’s just an idea", from: "How close are you to applying for teacher training?"
    select "Graduate or postgraduate", from: "Do you have a degree?"
    select "Maths", from: "What would you like to teach?"
    check "I am over 16 years old and accept the terms and conditions"
  end

  context "when the user doesn't exist in the CRM" do
    before do
      allow_any_instance_of(MailingList::Signup).to(receive(:already_signed_up?).and_return(false))
    end

    specify "registering and confirming identity using a verification code" do
      visit new_mailing_list_signup_path

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

      enter_candidate_details

      click_on "Register"

      expect(page).to have_current_path(edit_mailing_list_signup_path)
      expect(page).to have_field("Verification code")
      expect(page).to have_css(".button", text: "Verify")

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

      allow_any_instance_of(MailingList::Signup).to receive(:already_subscribed_to_mailing_list).and_return(true)
    end

    specify "registering and confirming identity using a verification code" do
      visit new_mailing_list_signup_path

      enter_candidate_details

      click_on "Register"

      expect(page).to have_current_path(edit_mailing_list_signup_path)
      expect(page).to have_field("Verification code")
      expect(page).to have_css(".button", text: "Verify")

      fill_in "Verification code", with: "123456"

      click_on "Verify"

      expect(page).to have_current_path(mailing_list_step_path("already_subscribed"))
    end
  end
end
