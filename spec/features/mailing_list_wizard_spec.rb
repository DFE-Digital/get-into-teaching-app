require "rails_helper"

RSpec.feature "Mailing list wizard", type: :feature do
  let(:describe_yourself_option_types) do
    GetIntoTeachingApi::Constants::DESCRIBE_YOURSELF_OPTIONS.map do |k, v|
      GetIntoTeachingApiClient::TypeEntity.new({ id: v, value: k })
    end
  end

  let(:degree_status_option_types) do
    GetIntoTeachingApi::Constants::DEGREE_STATUS_OPTIONS.map do |k, v|
      GetIntoTeachingApiClient::TypeEntity.new({ id: v, value: k })
    end
  end

  let(:consideration_journey_stage_types) do
    GetIntoTeachingApi::Constants::CONSIDERATION_JOURNEY_STAGES.map do |k, v|
      GetIntoTeachingApiClient::TypeEntity.new({ id: v, value: k })
    end
  end

  let(:teaching_subject_types) do
    GetIntoTeachingApi::Constants::TEACHING_SUBJECTS.map do |k, v|
      GetIntoTeachingApiClient::TypeEntity.new({ id: v, value: k })
    end
  end

  let(:latest_privacy_policy) { GetIntoTeachingApiClient::PrivacyPolicy.new({ id: 123 }) }

  before do
    allow_any_instance_of(GetIntoTeachingApiClient::TypesApi).to \
      receive(:get_candidate_describe_yourself_options).and_return(describe_yourself_option_types)
    allow_any_instance_of(GetIntoTeachingApiClient::TypesApi).to \
      receive(:get_qualification_degree_status).and_return(degree_status_option_types)
    allow_any_instance_of(GetIntoTeachingApiClient::TypesApi).to \
      receive(:get_candidate_journey_stages).and_return(consideration_journey_stage_types)
    allow_any_instance_of(GetIntoTeachingApiClient::TypesApi).to \
      receive(:get_teaching_subjects).and_return(teaching_subject_types)
    allow_any_instance_of(GetIntoTeachingApiClient::PrivacyPoliciesApi).to \
      receive(:get_latest_privacy_policy).and_return(latest_privacy_policy)
    allow_any_instance_of(GetIntoTeachingApiClient::MailingListApi).to \
      receive(:add_mailing_list_member)
  end

  scenario "Full journey as a new Student" do
    allow_any_instance_of(GetIntoTeachingApiClient::CandidatesApi).to \
      receive(:create_candidate_access_token).and_raise(GetIntoTeachingApiClient::ApiError)

    visit mailing_list_steps_path

    expect(page).to have_text "Sign up for personalised updates"
    fill_in_name_step(describe_yourself: "Student")
    click_on "Next Step"

    expect(page).to have_text "Your degree stage"
    select "Graduate or postgraduate"
    click_on "Next Step"

    expect(page).to have_text "How close are you to applying"
    select "I’m not sure and finding out more"
    click_on "Next Step"

    expect(page).to have_text "Which subject do you want to teach"
    select "Maths"
    click_on "Next Step"

    expect(page).to have_text "Events in your area"
    fill_in "What's your postcode", with: "TE57 1NG"
    click_on "Next Step"

    expect(page).to have_text "If you need more information"
    fill_in_contact_step
    click_on "Complete sign up"

    expect(page).to have_text "If you need more information"
    expect(page).to have_text "There is a problem"
    expect(page).to have_text "Accept the privacy policy to continue"
    check "Yes"
    click_on "Complete sign up"

    expect(page).to have_text "You've signed up"
    expect(page).to have_text "What happens next"
  end

  scenario "Full journey as an existing non-Student" do
    allow_any_instance_of(GetIntoTeachingApiClient::CandidatesApi).to \
      receive(:create_candidate_access_token)

    response = GetIntoTeachingApiClient::MailingListAddMember.new(
      preferredTeachingSubjectId: GetIntoTeachingApi::Constants::TEACHING_SUBJECTS["Maths"],
      considerationJourneyStageId: GetIntoTeachingApi::Constants::CONSIDERATION_JOURNEY_STAGES["I’m very sure and think I’ll apply"],
      degreeStatusId: GetIntoTeachingApi::Constants::DEGREE_STATUS_OPTIONS["Final year"],
      addressPostcode: "TE57 1NG",
      telephone: "1234567890",
      callbackInformation: "Please call me back!",
    )
    allow_any_instance_of(GetIntoTeachingApiClient::MailingListApi).to \
      receive(:get_pre_filled_mailing_list_add_member).with("123456", anything).and_return(response)

    visit mailing_list_steps_path

    expect(page).to have_text "Sign up for personalised updates"
    fill_in_name_step(describe_yourself: "Looking to change career")
    click_on "Next Step"

    expect(page).to have_text "Verify your account"
    fill_in "Enter the verification code sent to test@user.com", with: "123456"
    click_on "Next Step"

    expect(page).to have_text "How close are you to applying"
    expect(page).to have_select(
      "How close are you to applying for teacher training?",
      selected: GetIntoTeachingApi::Constants::CONSIDERATION_JOURNEY_STAGES.key(response.consideration_journey_stage_id),
    )
    click_on "Next Step"

    expect(page).to have_text "Which subject do you want to teach"
    expect(page).to have_select(
      "Which subject do you want to teach?",
      selected: GetIntoTeachingApi::Constants::TEACHING_SUBJECTS.key(response.preferred_teaching_subject_id),
    )
    click_on "Next Step"

    expect(page).to have_text "Events in your area"
    expect(page).to have_field("What's your postcode?", with: response.address_postcode)
    click_on "Next Step"

    expect(page).to have_text "If you need more information"
    expect(page).to have_field("What's your phone number (optional)", with: response.telephone)
    expect(page).to have_field(
      "What would you like more information about when we call you?",
      with: response.callback_information,
    )
    click_on "Complete sign up"

    expect(page).to have_text "If you need more information"
    expect(page).to have_text "There is a problem"
    expect(page).to have_text "Accept the privacy policy to continue"
    check "Yes"
    click_on "Complete sign up"

    expect(page).to have_text "You've signed up"
    expect(page).to have_text "What happens next"
  end

  scenario "Full journey as a returning candidate that resends the verification code" do
    allow_any_instance_of(GetIntoTeachingApiClient::CandidatesApi).to \
      receive(:create_candidate_access_token)

    response = GetIntoTeachingApiClient::MailingListAddMember.new
    allow_any_instance_of(GetIntoTeachingApiClient::MailingListApi).to \
      receive(:get_pre_filled_mailing_list_add_member).with("654321", anything).and_raise(GetIntoTeachingApiClient::ApiError)
    allow_any_instance_of(GetIntoTeachingApiClient::MailingListApi).to \
      receive(:get_pre_filled_mailing_list_add_member).with("123456", anything).and_return(response)

    visit mailing_list_steps_path

    expect(page).to have_text "Sign up for personalised updates"
    fill_in_name_step(describe_yourself: "Looking to change career")
    click_on "Next Step"

    expect(page).to have_text "Verify your account"
    fill_in "Enter the verification code sent to test@user.com", with: "654321"
    click_on "Next Step"

    expect(page).to have_text "is not correct"

    click_link "resend verification"
    expect(page).to have_text "We've sent you another email."

    fill_in "Enter the verification code sent to test@user.com", with: "123456"
    click_on "Next Step"

    expect(page).to have_text "How close are you to applying"
  end

  def fill_in_name_step(
    first_name: "Test",
    last_name: "User",
    email: "test@user.com",
    describe_yourself: nil
  )
    fill_in "First name", with: first_name if first_name
    fill_in "Surname", with: last_name if last_name
    fill_in "Email address", with: email if email
    select describe_yourself if describe_yourself
  end

  def fill_in_contact_step(
    telephone: "01234567890",
    callback_information: "Lorem ipsum"
  )
    fill_in "What's your phone number", with: telephone
    fill_in "What would you like more information about", with: callback_information
  end
end
