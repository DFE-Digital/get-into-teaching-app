require "rails_helper"

RSpec.feature "Mailing list wizard", type: :feature do
  include_context "with wizard data"

  before do
    allow(Rails.application.config.x).to \
      receive(:mailing_list_age_step).and_return(age_step_enabled)
  end

  context "when the age step is enabled" do
    let(:age_step_enabled) { true }
    let(:candidate_identity) { new_candidate_identity }

    scenario "age_dislay_option is 'none'" do
      stub_age_display_option(MailingList::Steps::Age::DISPLAY_OPTIONS.slice(:none))
      visit mailing_list_steps_path

      submit_name_step(candidate_identity)
      expect_not_current_step(:age)
    end

    scenario "age_dislay_option is 'date_of_birth'" do
      stub_age_display_option(MailingList::Steps::Age::DISPLAY_OPTIONS.slice(:date_of_birth))
      visit mailing_list_steps_path

      submit_name_step(candidate_identity)
      submit_age_date_of_birth_step
    end

    scenario "age_dislay_option is 'year_of_birth'" do
      stub_age_display_option(MailingList::Steps::Age::DISPLAY_OPTIONS.slice(:year_of_birth))
      visit mailing_list_steps_path

      submit_name_step(candidate_identity)
      submit_input_step("Year", "1967", :age)
    end

    scenario "age_dislay_option is 'age_range'" do
      stub_age_display_option(MailingList::Steps::Age::DISPLAY_OPTIONS.slice(:age_range))
      visit mailing_list_steps_path

      submit_name_step(candidate_identity)
      submit_choice_step("50+", :age)
    end

    scenario "restarting the form retains the age display option" do
      stub_age_display_option(MailingList::Steps::Age::DISPLAY_OPTIONS.slice(:date_of_birth))
      visit mailing_list_steps_path

      submit_name_step(candidate_identity)
      expect(page.body).to include("age-step-display-option-value=\"date_of_birth\"")

      stub_age_display_option(MailingList::Steps::Age::DISPLAY_OPTIONS.slice(:age_range))
      visit mailing_list_steps_path

      submit_name_step(candidate_identity)
      expect(page.body).to include("age-step-display-option-value=\"date_of_birth\"")
    end
  end

  context "with a new candidate" do
    let(:age_step_enabled) { false }
    let(:candidate_identity) { new_candidate_identity }

    scenario "full journey" do
      visit mailing_list_steps_path

      submit_name_step(candidate_identity)
      submit_choice_step("Not yet, I'm a first year student", :degree_status)
      submit_choice_step("I’m not sure and finding out more", :teacher_training)
      submit_select_step("Maths", :subject)
      submit_input_step("mailing_list_steps_postcode[address_postcode]", "TE51NG", :postcode)

      expect_sign_up_with_attributes(candidate_attributes)
      submit_privacy_policy_step
    end

    scenario "full journey (on-campus sign up)" do
      channel_id = GetIntoTeachingApiClient::Constants::\
        CANDIDATE_MAILING_LIST_SUBSCRIPTION_CHANNELS["GITIS - On Campus - Students Union Media"]

      visit mailing_list_step_path(:name, channel: channel_id)

      submit_name_step(candidate_identity)
      submit_choice_step("Not yet, I'm a first year student", :degree_status)
      submit_choice_step("I’m not sure and finding out more", :teacher_training)
      submit_select_step("Maths", :subject)
      submit_input_step("mailing_list_steps_postcode[address_postcode]", "TE51NG", :postcode)

      expect_sign_up_with_attributes(candidate_attributes.merge(channel_id: channel_id))
      submit_privacy_policy_step
    end

    scenario "partial journey encountering an error" do
      visit mailing_list_steps_path

      click_on "Next step"

      expect(page).to have_text "There is a problem"
      expect(page).to have_text "Enter your first name"
      expect(page).to have_text "Enter your last name"
      expect(page).to have_text "Enter your full email address"
    end
  end

  context "with an existing candidate" do
    let(:age_step_enabled) { false }
    let(:candidate_identity) { existing_candidate_identity }

    scenario "full journey, changing an answer (re-sends verification code)" do
      visit mailing_list_steps_path

      submit_name_step(candidate_identity)
      mock_exchange_code_for_candidate("123456")
      enter_verification_code_and_continue(candidate_identity[:email], "123456", "000000")
      submit_pre_filled_choice_step("Not yet, I'm a first year student", :degree_status)
      submit_pre_filled_choice_step("I’m not sure and finding out more", :teacher_training)
      submit_select_step("Physics", :subject)

      request_attributes = candidate_attributes.merge({
        preferred_teaching_subject_id: GetIntoTeachingApiClient::Constants::TEACHING_SUBJECTS["Physics"],
      })
      expect_sign_up_with_attributes(request_attributes)
      submit_privacy_policy_step
    end

    scenario "already subscribed to mailing list" do
      visit mailing_list_steps_path

      submit_name_step(candidate_identity)
      mock_exchange_code_for_candidate("123456", { already_subscribed_to_mailing_list: true })
      enter_verification_code_and_continue(candidate_identity[:email], "123456")
      expect_exit_step("You’ve already signed up")
    end

    scenario "already subscribed to teacher training adviser service" do
      visit mailing_list_steps_path

      submit_name_step(candidate_identity)
      mock_exchange_code_for_candidate("123456", { already_subscribed_to_teacher_training_adviser: true })
      enter_verification_code_and_continue(candidate_identity[:email], "123456")
      expect_current_step(:degree_status)
    end

    scenario "using a magic link" do
      token = "magic-link-token"
      mock_exchange_magic_link_token_for_candidate(token)

      visit mailing_list_steps_path(magic_link_token: token)

      expect(page).to have_text "Tell us more about you so that you only get emails relevant to your circumstances."

      submit_pre_filled_choice_step("Not yet, I'm a first year student", :degree_status)
      submit_pre_filled_choice_step("I’m not sure and finding out more", :teacher_training)
      submit_pre_filled_select_step("Maths", :subject)

      expect_sign_up_with_attributes(candidate_attributes)
      submit_privacy_policy_step
    end

    scenario "using invalid magic links" do
      visit mailing_list_steps_path(magic_link_token_error: GetIntoTeachingApiClient::ExchangeStatus::INVALID)
      expect(page).to have_text "We could not find this link"

      visit mailing_list_steps_path(magic_link_token_error: GetIntoTeachingApiClient::ExchangeStatus::EXPIRED)
      expect(page).to have_text "This link has expired"

      visit mailing_list_steps_path(magic_link_token_error: GetIntoTeachingApiClient::ExchangeStatus::ALREADY_EXCHANGED)
      expect(page).to have_text "This link has been used already"

      visit mailing_list_steps_path(magic_link_token_error: "UnknownError")
      expect(page).to have_text "We could not find this link"
    end

    scenario "switching to a new candidate" do
      visit mailing_list_steps_path

      submit_name_step(candidate_identity)
      mock_exchange_code_for_candidate("123456", { already_subscribed_to_mailing_list: true })
      enter_verification_code_and_continue(candidate_identity[:email], "123456")
      expect_exit_step("You’ve already signed up")

      visit mailing_list_steps_path

      candidate_identity[:existing] = false
      submit_name_step(candidate_identity)
      submit_choice_step("Not yet, I'm a first year student", :degree_status)
      submit_choice_step("I’m not sure and finding out more", :teacher_training)
      submit_select_step("Maths", :subject)
      submit_input_step("mailing_list_steps_postcode[address_postcode]", "", :postcode)

      expect_sign_up_with_attributes(candidate_attributes.merge({ address_postcode: nil }))
      submit_privacy_policy_step
    end
  end

  def mock_exchange_code_for_candidate(valid_code, response_attributes = {})
    allow_any_instance_of(GetIntoTeachingApiClient::MailingListApi).to \
      receive(:exchange_access_token_for_mailing_list_add_member).with(anything, anything) do |_, code|
      raise GetIntoTeachingApiClient::ApiError unless code == valid_code

      attributes = candidate_attributes.merge(response_attributes).transform_keys { |k| k.to_s.camelize(:lower) }
      GetIntoTeachingApiClient::MailingListAddMember.new(attributes)
    end
  end

  def mock_exchange_magic_link_token_for_candidate(valid_token, response_attributes = {})
    allow_any_instance_of(GetIntoTeachingApiClient::MailingListApi).to \
      receive(:exchange_magic_link_token_for_mailing_list_add_member).with(valid_token) do
      attributes = candidate_attributes.merge(response_attributes).transform_keys { |k| k.to_s.camelize(:lower) }
      GetIntoTeachingApiClient::MailingListAddMember.new(attributes)
    end
  end

  def expect_sign_up_with_attributes(attributes)
    expect_any_instance_of(GetIntoTeachingApiClient::MailingListApi).to \
      receive(:add_mailing_list_member)
      .with(having_attributes(attributes))
      .once
  end

  def candidate_attributes
    candidate_identity.except(:existing).merge({
      degree_status_id: GetIntoTeachingApiClient::Constants::DEGREE_STATUS_OPTIONS["First year"],
      consideration_journey_stage_id: GetIntoTeachingApiClient::Constants::CONSIDERATION_JOURNEY_STAGES["I’m not sure and finding out more"],
      preferred_teaching_subject_id: GetIntoTeachingApiClient::Constants::TEACHING_SUBJECTS["Maths"],
      address_postcode: "TE51NG",
      accepted_policy_id: "123",
    })
  end

  def submit_age_date_of_birth_step
    expect_current_step(:age)
    fill_in("Day", with: 1)
    fill_in("Month", with: 2)
    fill_in("Year", with: 1993)
    click_on_next_step
  end

  def stub_age_display_option(age_display_option)
    stub_const(
      "MailingList::Steps::Age::DISPLAY_OPTIONS",
      age_display_option,
    )
  end
end
