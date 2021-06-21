require "rails_helper"

RSpec.feature "Mailing list signup", type: :feature do
  include_context "stub types api"
  include_context "stub candidate create access token api"

  let(:qualification_id) { "QQQ" }
  let(:candidate_id) { "CCC" }
  let(:privacy_policy_id) { "PP-ABC-123" }

  before do
    allow_any_instance_of(GetIntoTeachingApiClient::PrivacyPoliciesApi).to receive(:get_latest_privacy_policy).and_return(OpenStruct.new(id: privacy_policy_id))
  end

  def form_choices
    {
      first_name: { value: "Milhouse" },
      last_name: { value: "van Houten" },
      email: { value: "mvh@hotmail.com" },
      consideration_journey_stage_id: { option: "It’s just an idea", value: 222_750_000 },
      degree_status_id: { option: "Graduate or postgraduate", value: 222_750_000 },
      preferred_teaching_subject_id: { option: "Maths", value: "a42655a1-2afa-e811-a981-000d3a276620" },
    }
  end

  def enter_candidate_details
    fill_in "First name",
            with: form_choices.dig(:first_name, :value)

    fill_in "Last name",
            with: form_choices.dig(:last_name, :value)

    fill_in "Email address",
            with: form_choices.dig(:email, :value)

    select form_choices.dig(:consideration_journey_stage_id, :option),
           from: "How close are you to applying for teacher training?"

    select form_choices.dig(:degree_status_id, :option),
           from: "Do you have a degree?"

    select form_choices.dig(:preferred_teaching_subject_id, :option),
           from: "What would you like to teach?"

    check "I am over 16 years old and accept the privacy policy"
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
      "What is your postcode? (optional)",
      "What would you like to teach?",
      "I am over 16 years old and accept the privacy policy",
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

  def successful_submission_body
    {
      accepted_policy_id: privacy_policy_id,
      address_postcode: "",
      preferred_teaching_subject_id: form_choices.dig(:preferred_teaching_subject_id, :value),
      consideration_journey_stage_id: form_choices.dig(:consideration_journey_stage_id, :value),
      degree_status_id: form_choices.dig(:degree_status_id, :value),
      first_name: form_choices.dig(:first_name, :value),
      last_name: form_choices.dig(:last_name, :value),
      email: form_choices.dig(:email, :value),
    }
  end

  context "when the user doesn't exist in the CRM" do
    let(:members_body) do
      successful_submission_body.transform_keys { |k| k.to_s.camelcase(:lower) }
    end

    before do
      stub_request(:post, "#{git_api_endpoint}/api/candidates/access_tokens")
        .to_return(status: 404, body: "", headers: {})

      stub_request(:post, "#{git_api_endpoint}/api/mailing_list/members")
        .with(body: members_body)
        .to_return(status: 200, body: "", headers: {})
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

      expect(WebMock).to have_requested(:post, "#{git_api_endpoint}/api/mailing_list/members").with(body: members_body).once
      expect(page).to have_current_path(completed_mailing_list_steps_path)
    end
  end

  context "when the user exists in the CRM" do
    let(:exchange_access_token_body) do
      successful_submission_body
        .slice(:email, :first_name, :last_name)
        .transform_keys { |k| k.to_s.camelcase(:lower) }
    end

    let(:members_body) do
      successful_submission_body
        .merge(candidate_id: candidate_id, qualification_id: qualification_id)
        .transform_keys { |k| k.to_s.camelcase(:lower) }
    end

    before do
      # request one, user has CRM record but `already_subscribed_to_mailing_list: false`
      stub_request(:post, "#{git_api_endpoint}/api/mailing_list/members/exchange_access_token/123456")
        .with(body: exchange_access_token_body)
        .to_return(
          status: 200, body: {
            already_subscribed_to_mailing_list: false,
            candidate_id: candidate_id,
            qualification_id: qualification_id,
          }.transform_keys { |k| k.to_s.camelcase(:lower) }.to_json,
          headers: {}
        )

      # request two, updating the CRM record identified by qualification_id and candidate_id
      stub_request(:post, "#{git_api_endpoint}/api/mailing_list/members")
        .with(body: members_body)
        .to_return(status: 200, body: "", headers: {})
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

      expect(WebMock).to have_requested(:post, "#{git_api_endpoint}/api/mailing_list/members/exchange_access_token/123456").with(body: exchange_access_token_body).once
      expect(WebMock).to have_requested(:post, "#{git_api_endpoint}/api/mailing_list/members").with(body: members_body).once
      expect(page).to have_current_path(completed_mailing_list_steps_path)
    end
  end

  context "when the user is already on the mailing list" do
    let(:exchange_access_token_body) do
      successful_submission_body
        .slice(:email, :first_name, :last_name)
        .transform_keys { |k| k.to_s.camelcase(:lower) }
    end

    before do
      # unsuccessful
      stub_request(:post, "#{git_api_endpoint}/api/mailing_list/members/exchange_access_token/234567")
        .with(body: exchange_access_token_body)
        .to_return(status: 404, body: "", headers: {})

      # successful
      stub_request(:post, "#{git_api_endpoint}/api/mailing_list/members/exchange_access_token/123456")
        .with(body: exchange_access_token_body)
        .to_return(
          status: 200, body: {
            already_subscribed_to_mailing_list: true,
            candidate_id: candidate_id,
            qualification_id: qualification_id,
          }.transform_keys { |k| k.to_s.camelcase(:lower) }.to_json,
          headers: {}
        )
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

      expect(WebMock).to have_requested(:post, "#{git_api_endpoint}/api/mailing_list/members/exchange_access_token/234567").with(body: exchange_access_token_body).once
      expect(WebMock).to have_requested(:post, "#{git_api_endpoint}/api/mailing_list/members/exchange_access_token/123456").with(body: exchange_access_token_body).once
      expect(page).to have_current_path(mailing_list_step_path("already_subscribed"))
    end
  end
end
