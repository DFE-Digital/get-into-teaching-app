require "rails_helper"

RSpec.feature "Mailing list wizard", type: :feature do
  let(:degree_status_option_types) do
    GetIntoTeachingApiClient::Constants::DEGREE_STATUS_OPTIONS.map do |k, v|
      GetIntoTeachingApiClient::TypeEntity.new({ id: v, value: k })
    end
  end

  let(:consideration_journey_stage_types) do
    GetIntoTeachingApiClient::Constants::CONSIDERATION_JOURNEY_STAGES.map do |k, v|
      GetIntoTeachingApiClient::TypeEntity.new({ id: v, value: k })
    end
  end

  let(:teaching_subject_types) do
    GetIntoTeachingApiClient::Constants::TEACHING_SUBJECTS.map do |k, v|
      GetIntoTeachingApiClient::TypeEntity.new({ id: v, value: k })
    end
  end

  let(:channels) do
    GetIntoTeachingApiClient::Constants::CANDIDATE_MAILING_LIST_SUBSCRIPTION_CHANNELS.map do |k, v|
      GetIntoTeachingApiClient::TypeEntity.new({ id: v, value: k })
    end
  end

  let(:latest_privacy_policy) { GetIntoTeachingApiClient::PrivacyPolicy.new({ id: 123 }) }

  before do
    allow_any_instance_of(GetIntoTeachingApiClient::TypesApi).to \
      receive(:get_qualification_degree_status).and_return(degree_status_option_types)
    allow_any_instance_of(GetIntoTeachingApiClient::TypesApi).to \
      receive(:get_candidate_journey_stages).and_return(consideration_journey_stage_types)
    allow_any_instance_of(GetIntoTeachingApiClient::TypesApi).to \
      receive(:get_teaching_subjects).and_return(teaching_subject_types)
    allow_any_instance_of(GetIntoTeachingApiClient::TypesApi).to \
      receive(:get_candidate_mailing_list_subscription_channels).and_return(channels)
    allow_any_instance_of(GetIntoTeachingApiClient::PrivacyPoliciesApi).to \
      receive(:get_latest_privacy_policy).and_return(latest_privacy_policy)
    allow_any_instance_of(GetIntoTeachingApiClient::MailingListApi).to \
      receive(:add_mailing_list_member)
  end

  include_context "prepend fake views"

  scenario "Full journey as a new candidate" do
    allow_any_instance_of(GetIntoTeachingApiClient::CandidatesApi).to \
      receive(:create_candidate_access_token).and_raise(GetIntoTeachingApiClient::ApiError)

    visit mailing_list_steps_path

    expect(page).to have_text "Sign up for email updates"
    fill_in_name_step
    click_on "Next Step"

    expect(page).to have_text "What stage are you at with your degree?"
    choose "I am a first year student"
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

    expect(page).to have_text "Accept privacy policy"
    click_on "Complete sign up"

    expect(page).to have_text "Accept privacy policy"
    expect(page).to have_text "There is a problem"
    expect(page).to have_text "Accept the privacy policy to continue"
    check "Yes"
    click_on "Complete sign up"

    expect(page).to have_text "You've signed up"
    expect(page).to have_text "What happens next"
  end

  scenario "Full journey as an on-campus candidate" do
    allow_any_instance_of(GetIntoTeachingApiClient::CandidatesApi).to \
      receive(:create_candidate_access_token).and_raise(GetIntoTeachingApiClient::ApiError)

    channel_id = channels.first.id
    visit mailing_list_steps_path({ id: :name, channel: channel_id })

    expect(page).to have_text "Sign up for email updates"
    fill_in_name_step
    click_on "Next Step"

    expect(page).to have_text "What stage are you at with your degree?"
    choose "I am a first year student"
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

    expect(page).to have_text "Accept privacy policy"
    click_on "Complete sign up"

    expect(page).to have_text "Accept privacy policy"
    expect(page).to have_text "There is a problem"
    expect(page).to have_text "Accept the privacy policy to continue"
    check "Yes"
    click_on "Complete sign up"

    expect(page).to have_text "You've signed up"
    expect(page).to have_text "What happens next"
  end

  scenario "Full journey as an existing candidate" do
    allow_any_instance_of(GetIntoTeachingApiClient::CandidatesApi).to \
      receive(:create_candidate_access_token)

    response = GetIntoTeachingApiClient::MailingListAddMember.new(
      preferredTeachingSubjectId: GetIntoTeachingApiClient::Constants::TEACHING_SUBJECTS["Maths"],
      considerationJourneyStageId: GetIntoTeachingApiClient::Constants::CONSIDERATION_JOURNEY_STAGES["I’m very sure and think I’ll apply"],
      degreeStatusId: GetIntoTeachingApiClient::Constants::DEGREE_STATUS_OPTIONS["Final year"],
      addressPostcode: "TE57 1NG",
    )
    allow_any_instance_of(GetIntoTeachingApiClient::MailingListApi).to \
      receive(:get_pre_filled_mailing_list_add_member).with("123456", anything) { response }

    visit mailing_list_steps_path

    expect(page).to have_text "Sign up for email updates"
    fill_in_name_step
    click_on "Next Step"

    expect(page).to have_text "Verify your email address"
    fill_in "Enter the verification code sent to test@user.com", with: "123456"
    click_on "Next Step"

    expect(page).to have_text "What stage are you at with your degree?"
    expect(find("[name=\"mailing_list_steps_degree_status[degree_status_id]\"][checked]").value).to eq(
      response.degree_status_id.to_s,
    )
    click_on "Next Step"

    expect(page).to have_text "How close are you to applying"
    expect(page).to have_select(
      "How close are you to applying for teacher training?",
      selected: GetIntoTeachingApiClient::Constants::CONSIDERATION_JOURNEY_STAGES.key(response.consideration_journey_stage_id),
    )
    click_on "Next Step"

    expect(page).to have_text "Which subject do you want to teach"
    expect(page).to have_select(
      "Which subject do you want to teach?",
      selected: GetIntoTeachingApiClient::Constants::TEACHING_SUBJECTS.key(response.preferred_teaching_subject_id),
    )
    click_on "Next Step"

    expect(page).to have_text "Events in your area"
    expect(page).to have_field("What's your postcode?", with: response.address_postcode)
    click_on "Next Step"

    expect(page).to have_text "Accept privacy policy"
    click_on "Complete sign up"

    expect(page).to have_text "Accept privacy policy"
    expect(page).to have_text "There is a problem"
    expect(page).to have_text "Accept the privacy policy to continue"
    check "Yes"
    click_on "Complete sign up"

    expect(page).to have_text "You've signed up"
    expect(page).to have_text "What happens next"
  end

  scenario "Full journey as an existing candidate that resends the verification code" do
    allow_any_instance_of(GetIntoTeachingApiClient::CandidatesApi).to \
      receive(:create_candidate_access_token)

    response = GetIntoTeachingApiClient::MailingListAddMember.new
    allow_any_instance_of(GetIntoTeachingApiClient::MailingListApi).to \
      receive(:get_pre_filled_mailing_list_add_member).with("654321", anything).and_raise(GetIntoTeachingApiClient::ApiError)
    allow_any_instance_of(GetIntoTeachingApiClient::MailingListApi).to \
      receive(:get_pre_filled_mailing_list_add_member).with("123456", anything).and_return(response)

    visit mailing_list_steps_path

    expect(page).to have_text "Sign up for email updates"
    fill_in_name_step
    click_on "Next Step"

    expect(page).to have_text "Verify your email address"
    fill_in "Enter the verification code sent to test@user.com", with: "654321"
    click_on "Next Step"

    expect(page).to have_text "Please enter the latest verification code"

    click_link "resend verification"
    expect(page).to have_text "We've sent you another email."

    fill_in "Enter the verification code sent to test@user.com", with: "123456"
    click_on "Next Step"

    expect(page).to have_text "What stage are you at with your degree?"
  end

  scenario "Full journey as an existing candidate that has already subscribed to the mailing list" do
    allow_any_instance_of(GetIntoTeachingApiClient::CandidatesApi).to \
      receive(:create_candidate_access_token)

    response = GetIntoTeachingApiClient::MailingListAddMember.new(
      alreadySubscribedToMailingList: true,
    )
    allow_any_instance_of(GetIntoTeachingApiClient::MailingListApi).to \
      receive(:get_pre_filled_mailing_list_add_member).with("123456", anything).and_return(response)

    visit mailing_list_steps_path

    expect(page).to have_text "Sign up for email updates"
    fill_in_name_step
    click_on "Next Step"

    expect(page).to have_text "Verify your email address"
    fill_in "Enter the verification code sent to test@user.com", with: "123456"
    click_on "Next Step"

    expect(page).to have_text "You’ve already signed up"
    expect(page).to_not have_button("Next Step")
  end

  scenario "Full journey as an existing candidate that has already subscribed to a teacher training adviser" do
    allow_any_instance_of(GetIntoTeachingApiClient::CandidatesApi).to \
      receive(:create_candidate_access_token)

    response = GetIntoTeachingApiClient::MailingListAddMember.new(
      alreadySubscribedToTeacherTrainingAdviser: true,
    )
    allow_any_instance_of(GetIntoTeachingApiClient::MailingListApi).to \
      receive(:get_pre_filled_mailing_list_add_member).with("123456", anything).and_return(response)

    visit mailing_list_steps_path

    expect(page).to have_text "Sign up for email updates"
    fill_in_name_step
    click_on "Next Step"

    expect(page).to have_text "Verify your email address"
    fill_in "Enter the verification code sent to test@user.com", with: "123456"
    click_on "Next Step"

    expect(page).to have_text "You have already signed up to an adviser"
    expect(page).to_not have_button("Next Step")
  end

  scenario "Start as an existing candidate then switch to new candidate" do
    allow_any_instance_of(GetIntoTeachingApiClient::CandidatesApi).to \
      receive(:create_candidate_access_token)

    response = GetIntoTeachingApiClient::MailingListAddMember.new(
      alreadySubscribedToMailingList: true,
    )
    allow_any_instance_of(GetIntoTeachingApiClient::MailingListApi).to \
      receive(:get_pre_filled_mailing_list_add_member).with("123456", anything).and_return(response)

    visit mailing_list_steps_path

    expect(page).to have_text "Sign up for email updates"
    fill_in_name_step
    click_on "Next Step"

    expect(page).to have_text "Verify your email address"
    fill_in "Enter the verification code sent to test@user.com", with: "123456"
    click_on "Next Step"

    expect(page).to have_text "You’ve already signed up"
    click_link("Back")

    expect(page).to have_text "Verify your email address"
    click_link("Back")

    allow_any_instance_of(GetIntoTeachingApiClient::CandidatesApi).to \
      receive(:create_candidate_access_token).and_raise(GetIntoTeachingApiClient::ApiError)

    expect(page).to have_text "Sign up for email updates"
    fill_in_name_step(email: "test2@user.com")
    click_on "Next Step"

    expect(page).to have_text "What stage are you at with your degree?"
  end

  def fill_in_name_step(
    first_name: "Test",
    last_name: "User",
    email: "test@user.com"
  )
    fill_in "First name", with: first_name if first_name
    fill_in "Surname", with: last_name if last_name
    fill_in "Email address", with: email if email
  end
end
