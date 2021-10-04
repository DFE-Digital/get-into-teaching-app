require "rails_helper"

RSpec.feature "Mailing list wizard", type: :feature do
  include_context "with wizard data"

  let(:mailing_list_page_title) { "Get personalised guidance to your inbox, name step | Get Into Teaching" }

  before { allow(Rails.application.config.x).to receive(:mailing_list_age_step).and_return(false) }

  context "when mailing_list_age_step is true" do
    subject { page }

    before do
      allow(Rails.application.config.x).to receive(:mailing_list_age_step).and_return(true)

      allow_any_instance_of(GetIntoTeachingApiClient::CandidatesApi).to \
        receive(:create_candidate_access_token).and_raise(GetIntoTeachingApiClient::ApiError)
    end

    context "when restarting the form" do
      it "shows the same age step consistently" do
        stub_age_display_option(MailingList::Steps::Age::DISPLAY_OPTIONS.slice(:date_of_birth))
        visit mailing_list_steps_path

        fill_in_name_step
        click_on "Next step"

        expect(page).to have_text "How old are you?"
        expect(page).to have_field("Day")
        expect(page).to have_field("Month")
        expect(page).to have_field("Year")

        stub_age_display_option(MailingList::Steps::Age::DISPLAY_OPTIONS.slice(:date_of_birth))
        visit mailing_list_steps_path
        fill_in_name_step
        click_on "Next step"

        expect(page).to have_text "How old are you?"
        expect(page).to have_field("Day")
        expect(page).to have_field("Month")
        expect(page).to have_field("Year")
      end
    end

    context "when age_dislay_option is 'none'" do
      scenario "after completing the name step" do
        stub_age_display_option(MailingList::Steps::Age::DISPLAY_OPTIONS.slice(:none))
        visit mailing_list_steps_path
        fill_in_name_step
        click_on "Next step"
        expect(page).not_to have_text "How old are you?"
      end
    end

    context "when age_dislay_option is 'date_of_birth'" do
      scenario "after completing the name step" do
        stub_age_display_option(MailingList::Steps::Age::DISPLAY_OPTIONS.slice(:date_of_birth))
        visit mailing_list_steps_path
        fill_in_name_step
        click_on "Next step"
        expect(page).to have_text "How old are you?"
        fill_in "Day", with: 1
        fill_in "Month", with: 8
        fill_in "Year", with: 1982
        click_on "Next step"
      end
    end

    context "when age_dislay_option is 'year_of_birth'" do
      scenario "after completing the name step" do
        stub_age_display_option(MailingList::Steps::Age::DISPLAY_OPTIONS.slice(:year_of_birth))
        visit mailing_list_steps_path
        fill_in_name_step
        click_on "Next step"
        expect(page).to have_text "How old are you?"
        select "1967"
        click_on "Next step"
      end
    end

    context "when age_dislay_option is 'age_range'" do
      scenario "after completing the name step" do
        stub_age_display_option(MailingList::Steps::Age::DISPLAY_OPTIONS.slice(:age_range))
        visit mailing_list_steps_path
        fill_in_name_step
        click_on "Next step"
        expect(page).to have_text "How old are you?"
        choose "62 or older"
        click_on "Next step"
      end
    end
  end

  scenario "Full journey as a new candidate" do
    allow_any_instance_of(GetIntoTeachingApiClient::CandidatesApi).to \
      receive(:create_candidate_access_token).and_raise(GetIntoTeachingApiClient::ApiError)

    visit mailing_list_steps_path

    expect(page).to have_title(mailing_list_page_title)

    expect(page).to have_text "Get personalised guidance to your inbox"
    fill_in_name_step
    click_on "Next step"

    expect(page).not_to have_text "Tell us more about you so that you only get emails relevant to your circumstances."

    expect(page).to have_text "Do you have a degree?"
    choose "Not yet, I'm a first year student"
    click_on "Next step"

    expect(page).to have_text "How close are you to applying"
    choose "I’m not sure and finding out more"
    click_on "Next step"

    expect(page).to have_text "Which subject do you want to teach"
    select "Maths"
    click_on "Next step"

    expect(page).to have_text "events in your area"
    fill_in "Your postcode (optional)", with: "TE57 1NG"
    click_on "Next step"

    expect(page).to have_text "Accept privacy policy"
    click_on "Complete sign up"

    expect(page).to have_text "Accept privacy policy"
    expect(page).to have_text "There is a problem"
    expect(page).to have_text "Accept the privacy policy to continue"
    check "Yes"
    click_on "Complete sign up"

    expect(page).to have_title("You've signed up | Get Into Teaching")
    expect(page).to have_text "You've signed up"
    expect(page).to have_text("You'll receive a welcome email shortly")
  end

  scenario "Full journey as an on-campus candidate" do
    allow_any_instance_of(GetIntoTeachingApiClient::CandidatesApi).to \
      receive(:create_candidate_access_token).and_raise(GetIntoTeachingApiClient::ApiError)

    channel_id = channels.first.id
    visit mailing_list_steps_path({ id: :name, channel: channel_id })

    expect(page).to have_text "Get personalised guidance to your inbox"
    fill_in_name_step
    click_on "Next step"

    expect(page).to have_text "Do you have a degree?"
    choose "Not yet, I'm a first year student"
    click_on "Next step"

    expect(page).to have_text "How close are you to applying"
    choose "I’m not sure and finding out more"
    click_on "Next step"

    expect(page).to have_text "Which subject do you want to teach"
    select "Maths"
    click_on "Next step"

    expect(page).to have_text "events in your area"
    fill_in "Your postcode (optional)", with: "TE57 1NG"
    click_on "Next step"

    expect(page).to have_text "Accept privacy policy"
    click_on "Complete sign up"

    expect(page).to have_text "Accept privacy policy"
    expect(page).to have_text "There is a problem"
    expect(page).to have_text "Accept the privacy policy to continue"
    check "Yes"
    click_on "Complete sign up"

    expect(page).to have_text "You've signed up"
    expect(page).to have_text("You'll receive a welcome email shortly")
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
      receive(:exchange_access_token_for_mailing_list_add_member).with("123456", anything) { response }

    visit mailing_list_steps_path

    expect(page).to have_text "Get personalised guidance to your inbox"
    fill_in_name_step
    click_on "Next step"

    expect(page).to have_text "Verify your email address"
    fill_in "Check your email and enter the verification code sent to test@user.com", with: "123456"
    click_on "Next step"

    expect(page).to have_text "Do you have a degree?"
    expect(find("[name=\"mailing_list_steps_degree_status[degree_status_id]\"][checked]").value).to eq(
      response.degree_status_id.to_s,
    )
    click_on "Next step"

    expect(page).to have_text "How close are you to applying"
    expect(find("[name=\"mailing_list_steps_teacher_training[consideration_journey_stage_id]\"][checked]").value).to eq(
      response.consideration_journey_stage_id.to_s,
    )
    click_on "Next step"

    expect(page).to have_text "Which subject do you want to teach"
    expect(page).to have_select(
      "Which subject do you want to teach?",
      selected: GetIntoTeachingApiClient::Constants::TEACHING_SUBJECTS.key(response.preferred_teaching_subject_id),
    )
    click_on "Next step"

    expect(page).to have_text "Accept privacy policy"
    click_on "Complete sign up"

    expect(page).to have_text "Accept privacy policy"
    expect(page).to have_text "There is a problem"
    expect(page).to have_text "Accept the privacy policy to continue"
    check "Yes"
    click_on "Complete sign up"

    expect(page).to have_text "You've signed up"
    expect(page).to have_text("You'll receive a welcome email shortly")
  end

  scenario "Full journey as an existing candidate that resends the verification code" do
    allow_any_instance_of(GetIntoTeachingApiClient::CandidatesApi).to \
      receive(:create_candidate_access_token)

    response = GetIntoTeachingApiClient::MailingListAddMember.new
    allow_any_instance_of(GetIntoTeachingApiClient::MailingListApi).to \
      receive(:exchange_access_token_for_mailing_list_add_member).with("654321", anything).and_raise(GetIntoTeachingApiClient::ApiError)
    allow_any_instance_of(GetIntoTeachingApiClient::MailingListApi).to \
      receive(:exchange_access_token_for_mailing_list_add_member).with("123456", anything).and_return(response)

    visit mailing_list_steps_path

    expect(page).to have_text "Get personalised guidance to your inbox"
    fill_in_name_step
    click_on "Next step"

    expect(page).to have_text "Verify your email address"
    fill_in "Check your email and enter the verification code sent to test@user.com", with: "654321"
    click_on "Next step"

    expect(page).to have_text "Please enter the latest verification code"

    click_link "resend verification"
    expect(page).to have_text "We've sent you another email."

    fill_in "Check your email and enter the verification code sent to test@user.com", with: "123456"
    click_on "Next step"

    expect(page).to have_text "Do you have a degree?"
  end

  scenario "Full journey as an existing candidate that has already subscribed to the mailing list" do
    allow_any_instance_of(GetIntoTeachingApiClient::CandidatesApi).to \
      receive(:create_candidate_access_token)

    response = GetIntoTeachingApiClient::MailingListAddMember.new(
      alreadySubscribedToMailingList: true,
    )
    allow_any_instance_of(GetIntoTeachingApiClient::MailingListApi).to \
      receive(:exchange_access_token_for_mailing_list_add_member).with("123456", anything).and_return(response)

    visit mailing_list_steps_path

    expect(page).to have_text "Get personalised guidance to your inbox"
    fill_in_name_step
    click_on "Next step"

    expect(page).to have_text "Verify your email address"
    fill_in "Check your email and enter the verification code sent to test@user.com", with: "123456"
    click_on "Next step"

    expect(page).to have_text "You’ve already signed up"
    expect(page).not_to have_button("Next step")
  end

  scenario "Full journey as an existing candidate that has already subscribed to a teacher training adviser" do
    allow_any_instance_of(GetIntoTeachingApiClient::CandidatesApi).to \
      receive(:create_candidate_access_token)

    response = GetIntoTeachingApiClient::MailingListAddMember.new(
      alreadySubscribedToTeacherTrainingAdviser: true,
    )
    allow_any_instance_of(GetIntoTeachingApiClient::MailingListApi).to \
      receive(:exchange_access_token_for_mailing_list_add_member).with("123456", anything).and_return(response)

    visit mailing_list_steps_path

    expect(page).to have_text "Get personalised guidance to your inbox"
    fill_in_name_step
    click_on "Next step"

    expect(page).to have_text "Verify your email address"
    fill_in "Check your email and enter the verification code sent to test@user.com", with: "123456"
    click_on "Next step"

    expect(page).to have_text "Do you have a degree?"
  end

  scenario "Full journey as an existing candidate using a magic link" do
    token = "magic-link-token"
    response = GetIntoTeachingApiClient::MailingListAddMember.new(
      firstName: "Test",
      lastName: "User",
      email: "test@user.com",
      considerationJourneyStageId: GetIntoTeachingApiClient::Constants::CONSIDERATION_JOURNEY_STAGES["I’m very sure and think I’ll apply"],
      degreeStatusId: GetIntoTeachingApiClient::Constants::DEGREE_STATUS_OPTIONS["Final year"],
    )
    allow_any_instance_of(GetIntoTeachingApiClient::MailingListApi).to \
      receive(:exchange_magic_link_token_for_mailing_list_add_member).with(token) { response }

    visit mailing_list_steps_path(magic_link_token: token)

    expect(page).to have_text "Tell us more about you so that you only get emails relevant to your circumstances."

    expect(page).to have_text "Do you have a degree?"
    expect(find("[name=\"mailing_list_steps_degree_status[degree_status_id]\"][checked]").value).to eq(
      response.degree_status_id.to_s,
    )
    click_on "Next step"

    expect(page).to have_text "How close are you to applying"
    expect(find("[name=\"mailing_list_steps_teacher_training[consideration_journey_stage_id]\"][checked]").value).to eq(
      response.consideration_journey_stage_id.to_s,
    )
    click_on "Next step"

    expect(page).to have_text "Which subject do you want to teach"
    select "Maths"
    click_on "Next step"

    expect(page).to have_text "events in your area"
    fill_in "Your postcode (optional)", with: "TE57 1NG"
    click_on "Next step"

    expect(page).to have_text "Accept privacy policy"
    check "Yes"
    click_on "Complete sign up"

    expect(page).to have_text "You've signed up"
    expect(page).to have_text("You'll receive a welcome email shortly")
  end

  scenario "Invalid magic link tokens" do
    visit mailing_list_steps_path(magic_link_token_error: GetIntoTeachingApiClient::ExchangeStatus::INVALID)
    expect(page).to have_text "We could not find this link"

    visit mailing_list_steps_path(magic_link_token_error: GetIntoTeachingApiClient::ExchangeStatus::EXPIRED)
    expect(page).to have_text "This link has expired"

    visit mailing_list_steps_path(magic_link_token_error: GetIntoTeachingApiClient::ExchangeStatus::ALREADY_EXCHANGED)
    expect(page).to have_text "This link has been used already"

    visit mailing_list_steps_path(magic_link_token_error: "UnknownError")
    expect(page).to have_text "We could not find this link"
  end

  scenario "Start as an existing candidate then switch to new candidate" do
    allow_any_instance_of(GetIntoTeachingApiClient::CandidatesApi).to \
      receive(:create_candidate_access_token)

    response = GetIntoTeachingApiClient::MailingListAddMember.new(
      alreadySubscribedToMailingList: true,
    )
    allow_any_instance_of(GetIntoTeachingApiClient::MailingListApi).to \
      receive(:exchange_access_token_for_mailing_list_add_member).with("123456", anything).and_return(response)

    visit mailing_list_steps_path

    expect(page).to have_text "Get personalised guidance to your inbox"
    fill_in_name_step
    click_on "Next step"

    expect(page).to have_text "Verify your email address"
    fill_in "Check your email and enter the verification code sent to test@user.com", with: "123456"
    click_on "Next step"

    expect(page).to have_text "You’ve already signed up"
    click_link("Back")

    expect(page).to have_text "Verify your email address"
    click_link("Back")

    allow_any_instance_of(GetIntoTeachingApiClient::CandidatesApi).to \
      receive(:create_candidate_access_token).and_raise(GetIntoTeachingApiClient::ApiError)

    expect(page).to have_text "Get personalised guidance to your inbox"
    fill_in_name_step(email: "test2@user.com")
    click_on "Next step"

    expect(page).to have_text "Do you have a degree?"
  end

  scenario "Partial journey with candidate encountering an error" do
    allow_any_instance_of(GetIntoTeachingApiClient::CandidatesApi).to \
      receive(:create_candidate_access_token).and_raise(GetIntoTeachingApiClient::ApiError)

    visit mailing_list_steps_path

    expect(page).to have_title(mailing_list_page_title)

    # try incorrectly first so we can check error state
    click_on "Next step"
    expect(page).to have_text "There is a problem"
    expect(page).to have_text "Enter your first name"
    expect(page).to have_text "Enter your last name"
    expect(page).to have_text "Enter your full email address"
    expect(page).to have_title(mailing_list_page_title)
  end

  def fill_in_name_step(
    first_name: "Test",
    last_name: "User",
    email: "test@user.com"
  )
    fill_in "First name", with: first_name if first_name
    fill_in "Last name", with: last_name if last_name
    fill_in "Email address", with: email if email
  end

  def stub_age_display_option(age_display_option)
    stub_const(
      "MailingList::Steps::Age::DISPLAY_OPTIONS",
      age_display_option,
    )
  end
end
