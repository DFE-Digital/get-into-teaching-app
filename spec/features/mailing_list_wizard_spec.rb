require "rails_helper"

RSpec.feature "View pages", type: :feature do
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

  before do
    allow_any_instance_of(GetIntoTeachingApiClient::CandidatesApi).to \
      receive(:create_candidate_access_token).and_raise(GetIntoTeachingApiClient::ApiError)
    allow_any_instance_of(GetIntoTeachingApiClient::TypesApi).to \
      receive(:get_candidate_describe_yourself_options).and_return(describe_yourself_option_types)
    allow_any_instance_of(GetIntoTeachingApiClient::TypesApi).to \
      receive(:get_qualification_degree_status).and_return(degree_status_option_types)
    allow_any_instance_of(GetIntoTeachingApiClient::TypesApi).to \
      receive(:get_candidate_journey_stages).and_return(consideration_journey_stage_types)
    allow_any_instance_of(GetIntoTeachingApiClient::TypesApi).to \
      receive(:get_teaching_subjects).and_return(teaching_subject_types)
  end

  scenario "Full journey as Student" do
    visit mailing_list_steps_path

    expect(page).to have_text "Sign up for personalised updates"
    fill_in "First name", with: "Test"
    fill_in "Surname", with: "User"
    fill_in "Email address", with: "test@testuser.com"
    select "Student"
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
    fill_in "What's your phone number", with: "01234567890"
    fill_in "What would you like more information about", with: "Lorem ipsum"
    click_on "Complete sign up"

    expect(page).to have_text "If you need more information"
    expect(page).to have_text "There is a problem"
    expect(page).to have_text "Accept the privacy policy to continue"
    check "Yes"
    click_on "Complete sign up"

    expect(page).to have_text "You've signed up"
    expect(page).to have_text "What happens next"
  end

  scenario "Full journey as non Student" do
    visit mailing_list_steps_path

    expect(page).to have_text "Sign up for personalised updates"
    fill_in "First name", with: "Test"
    fill_in "Surname", with: "User"
    fill_in "Email address", with: "test@testuser.com"
    select "Looking to change career"
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
    fill_in "What's your phone number", with: "01234567890"
    fill_in "What would you like more information about", with: "Lorem ipsum"
    click_on "Complete sign up"

    expect(page).to have_text "If you need more information"
    expect(page).to have_text "There is a problem"
    expect(page).to have_text "Accept the privacy policy to continue"
    check "Yes"
    click_on "Complete sign up"

    expect(page).to have_text "You've signed up"
    expect(page).to have_text "What happens next"
  end
end
