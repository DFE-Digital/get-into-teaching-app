require "rails_helper"

RETURNING_TO_TEACHING = 222_750_001
INTERESTED_IN_TEACHING = 222_750_000
EDUCATION_PHASE_PRIMARY = 222_750_000
EDUCATION_PHASE_SECONDARY = 222_750_001
DEGREE_STATUS_HAS_DEGREE = 222_750_000
DEGREE_STATUS_IN_PROGRESS = 222_750_006
DEGREE_TYPE_EQUIVALENT = 222_750_005
DEGREE_TYPE_DEGREE = 222_750_000
TEACHER_TRAINING_YEAR_2022 = 22_304
UK_DEGREE_GRADE_2_2 = 222_750_003
HAS_GCSE = 222_750_000
SUBJECT_PHYSICS = "ac2655a1-2afa-e811-a981-000d3a276620".freeze
SUBJECT_PSYCHOLOGY = "b22655a1-2afa-e811-a981-000d3a276620".freeze
SUBJECT_PRIMARY = "b02655a1-2afa-e811-a981-000d3a276620".freeze
CITIZENSHIP_UK = 222_750_000
CITIZENSHIP_NOT_UK = 222_750_001
VISA_STATUS_HAVE_VISA = 222_750_000
VISA_STATUS_WILL_NEED_VISA = 222_750_001
VISA_STATUS_NOT_SURE = 222_750_002

RSpec.feature "Sign up for a teacher training adviser", type: :feature do
  include_context "with wizard data"

  let(:quota) do
    GetIntoTeachingApiClient::CallbackBookingQuota.new(
      start_at: Time.find_zone("UTC").local(2099, 6, 1, 10),
      end_at: Time.find_zone("UTC").local(2099, 6, 1, 11),
    )
  end

  before do
    # Future callback booking slots (the VCR cassette contains outdated ones)
    allow_any_instance_of(GetIntoTeachingApiClient::CallbackBookingQuotasApi).to \
      receive(:get_callback_booking_quotas) { [quota].compact }
  end

  around do |example|
    travel_to(Date.new(2022, 6, 1)) do
      example.run
    end
  end

  context "when a new candidate" do
    let(:creation_channel_source_git_website) { 222_750_003 }
    let(:creation_channel_source_paid_advertising) { 222_750_009 }
    let(:creation_channel_service_mailing_list) { 222_750_007 }
    let(:creation_channel_service_rtta) { 222_750_009 }
    let(:creation_channel_service_tta) { 222_750_010 }
    let(:creation_channel_activity_student_union) { 222_750_021 }
    let(:sub_channel_id) { "abcdef" }

    let(:legacy_channels) do
      [
        GetIntoTeachingApiClient::PickListItem.new({ id: 222_750_028, value: "MailingList" }),
        GetIntoTeachingApiClient::PickListItem.new({ id: 222_750_029, value: "Event" }),
        GetIntoTeachingApiClient::PickListItem.new({ id: 222_750_027, value: "TeacherTrainingAdviser" }),
      ]
    end
    let(:creation_channel_sources) do
      [
        GetIntoTeachingApiClient::PickListItem.new({ id: 222_750_000, value: "Apply" }),
        GetIntoTeachingApiClient::PickListItem.new({ id: creation_channel_source_git_website, value: "GITWebsite" }),
        GetIntoTeachingApiClient::PickListItem.new({ id: creation_channel_source_paid_advertising, value: "PaidAdvertising" }),
      ]
    end
    let(:creation_channel_services) do
      [
        GetIntoTeachingApiClient::PickListItem.new({ id: 222_750_000, value: "CreatedOnApply" }),
        GetIntoTeachingApiClient::PickListItem.new({ id: 222_750_006, value: "Events" }),
        GetIntoTeachingApiClient::PickListItem.new({ id: creation_channel_service_mailing_list, value: "MailingList" }),
        GetIntoTeachingApiClient::PickListItem.new({ id: creation_channel_service_rtta, value: "ReturnToTeachingAdviserService" }),
        GetIntoTeachingApiClient::PickListItem.new({ id: creation_channel_service_tta, value: "TeacherTrainingAdviserService" }),
      ]
    end
    let(:creation_channel_activities) do
      [
        GetIntoTeachingApiClient::PickListItem.new({ id: 222_750_000, value: "BrandAmbassadorActivity" }),
        GetIntoTeachingApiClient::PickListItem.new({ id: 222_750_010, value: "GradFairs" }),
        GetIntoTeachingApiClient::PickListItem.new({ id: creation_channel_activity_student_union, value: "StudentUnionMedia" }),
      ]
    end

    before do
      # Emulate an unsuccessful matchback response from the API.
      allow_any_instance_of(GetIntoTeachingApiClient::CandidatesApi).to \
        receive(:create_candidate_access_token)
        .and_raise(GetIntoTeachingApiClient::ApiError)
      allow_any_instance_of(GetIntoTeachingApiClient::PickListItemsApi).to \
        receive(:get_candidate_teacher_training_adviser_subscription_channels).and_return(legacy_channels)
      allow_any_instance_of(GetIntoTeachingApiClient::PickListItemsApi).to \
        receive(:get_contact_creation_channel_sources).and_return(creation_channel_sources)
      allow_any_instance_of(GetIntoTeachingApiClient::PickListItemsApi).to \
        receive(:get_contact_creation_channel_services).and_return(creation_channel_services)
      allow_any_instance_of(GetIntoTeachingApiClient::PickListItemsApi).to \
        receive(:get_contact_creation_channel_activities).and_return(creation_channel_activities)
    end

    scenario "RTTA signing up at an on-campus event" do
      visit teacher_training_adviser_step_path(:identity, channel_activity: creation_channel_activity_student_union, sub_channel: sub_channel_id)
      click_on "Next step"

      expect(page).to have_css "h1", text: "Get a free adviser"
      # Simulate en error to ensure channel id is not lost
      click_on "Next step"
      expect(page).to have_text("You need to enter your first name")
      fill_in_identity_step
      click_on "Next step"

      expect(page).to have_css "h1", text: "Are you qualified to teach?"
      choose "Yes"
      click_on "Next step"

      expect(page).to have_css "h1", text: "Do you have a teacher reference number (TRN)?"
      choose "No"
      click_on "Next step"

      expect(page).to have_css "h1", text: "Do you have paid teaching experience in the UK of at least one term?"
      choose "Yes"
      click_on "Next step"

      expect(page).to have_css "h1", text: "Which stage did you previously teach?"
      choose "Secondary"
      click_on "Next step"

      expect(page).to have_css "h1", text: "Which main subject did you previously teach?"
      select "Psychology"
      click_on "Next step"

      expect(page).to have_css "h1", text: "Which stage are you most interested in teaching?"
      choose "Secondary"
      click_on "Next step"

      expect(page).to have_css "h1", text: "Which subject would you like to teach if you return to teaching?"
      select "Physics"
      click_on "Next step"

      expect(page).to have_css "h1", text: "Enter your date of birth"
      fill_in_date_of_birth_step
      click_on "Next step"

      expect(page).to have_css "h1", text: "Are you a UK citizen?"
      choose "Yes"
      click_on "Next step"

      # check page title remains correct for non completed steps
      expect(page).to have_css "h1", text: "Where do you live?"
      click_on "Next step"
      expect(page).to have_title("Error: Where do you live? - Adviser sign up | Get Into Teaching GOV.UK")
      choose "In the UK"
      click_on "Next step"

      expect(page).to have_css "h1", text: "What's your postcode?"
      fill_in_address_step
      click_on "Next step"

      expect(page).to have_css "h1", text: "What's your telephone number?"
      fill_in "UK telephone number (optional)", with: "123456789"
      click_on "Next step"

      expect(page).to have_css "h1", text: "Check your answers before you continue"

      request_attributes = uk_candidate_request_attributes({
        type_id: RETURNING_TO_TEACHING,
        subject_taught_id: SUBJECT_PSYCHOLOGY,
        preferred_teaching_subject_id: SUBJECT_PHYSICS,
        channel_id: nil,
        creation_channel_source_id: creation_channel_source_git_website,
        creation_channel_service_id: creation_channel_service_rtta,
        creation_channel_activity_id: creation_channel_activity_student_union,
        citizenship: CITIZENSHIP_UK,
      })
      expect_sign_up_with_attributes(request_attributes)

      click_on "Complete sign up"

      expect(page).to have_css "h1", text: "John, you're signed up."

      # We pass this to the BAM tracking pixel in GTM.
      expect(page).to have_selector("[data-sub-channel-id='#{sub_channel_id}']")
    end

    scenario "RTTA signing up at an on-campus event via adviser component (valid channel activity id)" do
      visit "/teacher-training-advisers?channel_source=#{creation_channel_source_paid_advertising}&channel_service=#{creation_channel_service_mailing_list}&channel_activity=#{creation_channel_activity_student_union}&sub_channel=#{sub_channel_id}"
      click_on "Next step"

      expect(page).to have_css "h1", text: "Get a free adviser"
      # Simulate en error to ensure channel id is not lost
      click_on "Next step"
      expect(page).to have_text("You need to enter your first name")
      fill_in_identity_step
      click_on "Next step"

      expect(page).to have_css "h1", text: "Are you qualified to teach?"
      choose "Yes"
      click_on "Next step"

      expect(page).to have_css "h1", text: "Do you have a teacher reference number (TRN)?"
      choose "No"
      click_on "Next step"

      expect(page).to have_css "h1", text: "Do you have paid teaching experience in the UK of at least one term?"
      choose "Yes"
      click_on "Next step"

      expect(page).to have_css "h1", text: "Which stage did you previously teach?"
      choose "Secondary"
      click_on "Next step"

      expect(page).to have_css "h1", text: "Which main subject did you previously teach?"
      select "Psychology"
      click_on "Next step"

      expect(page).to have_css "h1", text: "Which stage are you most interested in teaching?"
      choose "Secondary"
      click_on "Next step"

      expect(page).to have_css "h1", text: "Which subject would you like to teach if you return to teaching?"
      select "Physics"
      click_on "Next step"

      expect(page).to have_css "h1", text: "Enter your date of birth"
      fill_in_date_of_birth_step
      click_on "Next step"

      expect(page).to have_css "h1", text: "Are you a UK citizen?"
      choose "Yes"
      click_on "Next step"

      expect(page).to have_css "h1", text: "Where do you live?"
      choose "In the UK"
      click_on "Next step"

      expect(page).to have_css "h1", text: "What's your postcode?"
      fill_in_address_step
      click_on "Next step"

      expect(page).to have_css "h1", text: "What's your telephone number"
      fill_in "UK telephone number (optional)", with: "123456789"
      click_on "Next step"

      expect(page).to have_css "h1", text: "Check your answers before you continue"

      request_attributes = uk_candidate_request_attributes({
        type_id: RETURNING_TO_TEACHING,
        subject_taught_id: SUBJECT_PSYCHOLOGY,
        preferred_teaching_subject_id: SUBJECT_PHYSICS,
        channel_id: nil,
        creation_channel_source_id: creation_channel_source_paid_advertising,
        creation_channel_service_id: creation_channel_service_mailing_list,
        creation_channel_activity_id: creation_channel_activity_student_union,
        citizenship: CITIZENSHIP_UK,
      })
      expect_sign_up_with_attributes(request_attributes)

      click_on "Complete sign up"

      expect(page).to have_css "h1", text: "John, you're signed up."

      # We pass this to the BAM tracking pixel in GTM.
      expect(page).to have_selector("[data-sub-channel-id='#{sub_channel_id}']")
    end

    scenario "RTTA signing up at an on-campus event (invalid channel activity id)" do
      visit teacher_training_adviser_step_path(:identity, channel_activity: 999_999_999)
      click_on "Next step"

      expect(page).to have_css "h1", text: "Get a free adviser"
      fill_in_identity_step
      click_on "Next step"

      expect(page).to have_css "h1", text: "Are you qualified to teach?"
      choose "Yes"
      click_on "Next step"

      expect(page).to have_css "h1", text: "Do you have a teacher reference number (TRN)?"
      choose "No"
      click_on "Next step"

      expect(page).to have_css "h1", text: "Do you have paid teaching experience in the UK of at least one term?"
      choose "Yes"
      click_on "Next step"

      expect(page).to have_css "h1", text: "Which stage did you previously teach?"
      choose "Secondary"
      click_on "Next step"

      expect(page).to have_css "h1", text: "Which main subject did you previously teach?"
      select "Psychology"
      click_on "Next step"

      expect(page).to have_css "h1", text: "Which stage are you most interested in teaching?"
      choose "Secondary"
      click_on "Next step"

      expect(page).to have_css "h1", text: "Which subject would you like to teach if you return to teaching?"
      select "Physics"
      click_on "Next step"

      expect(page).to have_css "h1", text: "Enter your date of birth"
      fill_in_date_of_birth_step
      click_on "Next step"

      expect(page).to have_css "h1", text: "Are you a UK citizen?"
      choose "Yes"
      click_on "Next step"

      expect(page).to have_css "h1", text: "Where do you live?"
      choose "In the UK"
      click_on "Next step"

      expect(page).to have_css "h1", text: "What's your postcode?"
      fill_in_address_step
      click_on "Next step"

      expect(page).to have_css "h1", text: "What's your telephone number?"
      fill_in "UK telephone number (optional)", with: "123456789"
      click_on "Next step"

      expect(page).to have_css "h1", text: "Check your answers before you continue"

      request_attributes = uk_candidate_request_attributes({
        type_id: RETURNING_TO_TEACHING,
        subject_taught_id: SUBJECT_PSYCHOLOGY,
        preferred_teaching_subject_id: SUBJECT_PHYSICS,
        channel_id: nil,
        creation_channel_source_id: creation_channel_source_git_website,
        creation_channel_service_id: creation_channel_service_rtta,
        creation_channel_activity_id: nil,
        citizenship: CITIZENSHIP_UK,
      })
      expect_sign_up_with_attributes(request_attributes)

      click_on "Complete sign up"

      expect(page).to have_css "h1", text: "John, you're signed up."
    end

    scenario "that is a returning teacher" do
      visit teacher_training_adviser_steps_path

      expect(page).to have_css "h1", text: "Get a free adviser"
      fill_in_identity_step
      click_on "Next step"

      expect(page).to have_css "h1", text: "Are you qualified to teach?"
      choose "Yes"
      click_on "Next step"

      expect(page).to have_css "h1", text: "Do you have a teacher reference number (TRN)?"
      choose "Yes"
      click_on "Next step"

      expect(page).to have_css "h1", text: "What is your teacher reference number (TRN)?"
      fill_in "Teacher reference number (optional)", with: "1234"
      click_on "Next step"

      expect(page).to have_css "h1", text: "Do you have paid teaching experience in the UK of at least one term?"
      choose "Yes"
      click_on "Next step"

      expect(page).to have_css "h1", text: "Which stage did you previously teach?"
      choose "Secondary"
      click_on "Next step"

      expect(page).to have_css "h1", text: "Which main subject did you previously teach?"
      select "Psychology"
      click_on "Next step"

      expect(page).to have_css "h1", text: "Which stage are you most interested in teaching?"
      choose "Secondary"
      click_on "Next step"

      expect(page).to have_css "h1", text: "Which subject would you like to teach if you return to teaching?"
      select "Physics"
      click_on "Next step"

      expect(page).to have_css "h1", text: "Enter your date of birth"
      fill_in_date_of_birth_step
      click_on "Next step"

      expect(page).to have_css "h1", text: "Are you a UK citizen?"
      choose "No"
      click_on "Next step"

      expect(page).to have_css "h1", text: "Do you have a visa or immigration status allowing you to train to teach in England?"
      choose "Yes, I have a visa, pre-settled status or leave to remain"
      click_on "Next step"

      expect(page).to have_css "h1", text: "Where do you live?"
      choose "In the UK"
      click_on "Next step"

      expect(page).to have_css "h1", text: "What's your postcode"
      fill_in_address_step
      click_on "Next step"

      expect(page).to have_css "h1", text: "What's your telephone number?"
      fill_in "UK telephone number (optional)", with: "123456789"
      click_on "Next step"

      expect(page).to have_css "h1", text: "Check your answers before you continue"

      request_attributes = uk_candidate_request_attributes({
        type_id: RETURNING_TO_TEACHING,
        subject_taught_id: SUBJECT_PSYCHOLOGY,
        preferred_teaching_subject_id: SUBJECT_PHYSICS,
        teacher_id: "1234",
        channel_id: nil,
        creation_channel_source_id: creation_channel_source_git_website,
        creation_channel_service_id: creation_channel_service_rtta,
        creation_channel_activity_id: nil,
        citizenship: CITIZENSHIP_NOT_UK,
        visa_status: VISA_STATUS_HAVE_VISA,
      })
      expect_sign_up_with_attributes(request_attributes)

      click_on "Complete sign up"

      expect(page).to have_css "h1", text: "John, you're signed up."
      expect(page).to have_text "A return to teaching adviser will email you within 10 working days to outline your next steps"
      expect(page).to have_text "Get support returning to teaching"
      expect(page).not_to have_text "Discover the different ways to train"
      expect(page).not_to have_text "Find out about funding"
    end

    scenario "with an equivalent degree (overseas)" do
      visit teacher_training_adviser_steps_path

      expect(page).to have_css "h1", text: "Get a free adviser"
      fill_in_identity_step
      click_on "Next step"

      expect(page).to have_css "h1", text: "Are you qualified to teach?"
      choose "No"
      click_on "Next step"

      expect(page).to have_css "h1", text: "Do you have a degree?"
      choose "Yes"
      click_on "Next step"

      expect(page).to have_css "h1", text: "Which country is your degree from?"
      choose "Another Country"
      click_on "Next step"

      expect(page).to have_css "h1", text: "Enter your date of birth"
      fill_in_date_of_birth_step
      click_on "Next step"

      expect(page).to have_css "h1", text: "Where do you live?"
      choose "Outside of the UK"
      click_on "Next step"

      expect(page).to have_css "h1", text: "Which country do you live in?"
      select "Argentina"
      click_on "Next step"

      expect(page).to have_css "h1", text: "You need to speak to our team"
      expect(find_field("Your telephone number").value).to eq "54"
      fill_in "Your telephone number", with: "123456789"
      select "(GMT-10:00) Hawaii"
      click_on "Next step"

      expect(page).to have_text "Choose a time"
      # Select time in local time zone (Hawaii)
      select "12:00am to 1:00am", from: "Your preferred day and time for a callback"
      click_on "Next step"

      expect(page).to have_css "h1", text: "Check your answers before you continue"

      request_attributes = overseas_candidate_request_attributes({
        type_id: INTERESTED_IN_TEACHING,
        degree_status_id: DEGREE_STATUS_HAS_DEGREE,
        degree_type_id: DEGREE_TYPE_EQUIVALENT,
        phone_call_scheduled_at: "#{quota.start_at.strftime('%Y-%m-%dT%H:%M:%S')}.000Z",
        channel_id: nil,
        creation_channel_source_id: creation_channel_source_git_website,
        creation_channel_service_id: creation_channel_service_tta,
        creation_channel_activity_id: nil,
        date_of_birth: "1966-03-24",
      })

      expect_sign_up_with_attributes(request_attributes)

      click_on "Complete sign up"

      expect(page).to have_css "h1", text: "John, we'll give you a call"
      expect(page).to have_text "We'll give you a call at the time you selected."
    end

    scenario "with an equivalent degree (UK)" do
      visit teacher_training_adviser_steps_path

      expect(page).to have_css "h1", text: "Get a free adviser"
      fill_in_identity_step
      click_on "Next step"

      expect(page).to have_css "h1", text: "Are you qualified to teach?"
      choose "No"
      click_on "Next step"

      expect(page).to have_css "h1", text: "Do you have a degree?"
      choose "Yes"
      click_on "Next step"

      expect(page).to have_css "h1", text: "Which country is your degree from?"
      choose "Another Country"
      click_on "Next step"

      expect(page).to have_css "h1", text: "Enter your date of birth"
      fill_in_date_of_birth_step
      click_on "Next step"

      expect(page).to have_css "h1", text: "Where do you live?"
      choose "In the UK"
      click_on "Next step"

      expect(page).to have_css "h1", text: "You need to speak to our team"
      fill_in "Your telephone number", with: "123456789"
      # Select time in local time zone (London)
      select "11:00am to 12:00pm", from: "Your preferred day and time for a callback"
      click_on "Next step"

      expect(page).to have_css "h1", text: "Check your answers before you continue"

      request_attributes = uk_candidate_request_attributes({
        type_id: INTERESTED_IN_TEACHING,
        degree_status_id: DEGREE_STATUS_HAS_DEGREE,
        degree_type_id: DEGREE_TYPE_EQUIVALENT,
        phone_call_scheduled_at: "#{quota.start_at.strftime('%Y-%m-%dT%H:%M:%S')}.000Z",
        channel_id: nil,
        creation_channel_source_id: creation_channel_source_git_website,
        creation_channel_service_id: creation_channel_service_tta,
        creation_channel_activity_id: nil,
        date_of_birth: "1966-03-24",
        preferred_education_phase_id: nil,
        address_postcode: nil,
      })
      expect_sign_up_with_attributes(request_attributes)

      click_on "Complete sign up"

      expect(page).to have_css "h1", text: "John, we'll give you a call"
      expect(page).to have_text "We'll give you a call at the time you selected"
    end

    context "when there are no callback slots available" do
      let(:quota) { nil }

      scenario "with an equivalent degree" do
        visit teacher_training_adviser_steps_path

        expect(page).to have_css "h1", text: "Get a free adviser"
        fill_in_identity_step
        click_on "Next step"

        expect(page).to have_css "h1", text: "Are you qualified to teach?"
        choose "No"
        click_on "Next step"

        expect(page).to have_css "h1", text: "Do you have a degree?"
        choose "Yes"
        click_on "Next step"

        expect(page).to have_css "h1", text: "Which country is your degree from?"
        choose "Another Country"
        click_on "Next step"

        expect(page).to have_css "h1", text: "Enter your date of birth"
        fill_in_date_of_birth_step
        click_on "Next step"

        expect(page).to have_css "h1", text: "Where do you live?"
        choose "Outside of the UK"
        click_on "Next step"

        expect(page).to have_css "h1", text: "Which country do you live in?"
        select "Argentina"
        click_on "Next step"

        expect(page).to have_css "h1", text: "You need to speak to our team"
        expect(page).to have_text "When you call, our adviser will ask for more details about the qualification you have."
        click_on "Next step"

        expect(page).to have_css "h1", text: "Check your answers before you continue"

        request_attributes = overseas_candidate_request_attributes({
          type_id: INTERESTED_IN_TEACHING,
          degree_status_id: DEGREE_STATUS_HAS_DEGREE,
          degree_type_id: DEGREE_TYPE_EQUIVALENT,
          address_telephone: nil,
          channel_id: nil,
          creation_channel_source_id: creation_channel_source_git_website,
          creation_channel_service_id: creation_channel_service_tta,
          creation_channel_activity_id: nil,
          date_of_birth: "1966-03-24",
        })
        expect_sign_up_with_attributes(request_attributes)

        click_on "Complete sign up"

        expect(page).to have_css "h1", text: "John, give us a call"
        expect(page).to have_text "Please give us a call so that we can check your degree"
      end

      scenario "with an equivalent degree (UK)" do
        visit teacher_training_adviser_steps_path

        expect(page).to have_css "h1", text: "Get a free adviser"
        fill_in_identity_step
        click_on "Next step"

        expect(page).to have_css "h1", text: "Are you qualified to teach?"
        choose "No"
        click_on "Next step"

        expect(page).to have_css "h1", text: "Do you have a degree?"
        choose "Yes"
        click_on "Next step"

        expect(page).to have_css "h1", text: "Which country is your degree from?"
        choose "Another Country"
        click_on "Next step"

        expect(page).to have_css "h1", text: "Enter your date of birth"
        fill_in_date_of_birth_step
        click_on "Next step"

        expect(page).to have_css "h1", text: "Where do you live?"
        choose "In the UK"
        click_on "Next step"

        expect(page).to have_css "h1", text: "You need to speak to our team"
        expect(page).to have_text "Please have the details of your qualifications to hand when you call."
        click_on "Next step"

        expect(page).to have_css "h1", text: "Check your answers before you continue"

        request_attributes = uk_candidate_request_attributes({
          type_id: INTERESTED_IN_TEACHING,
          degree_status_id: DEGREE_STATUS_HAS_DEGREE,
          degree_type_id: DEGREE_TYPE_EQUIVALENT,
          address_telephone: nil,
          channel_id: nil,
          creation_channel_source_id: creation_channel_source_git_website,
          creation_channel_service_id: creation_channel_service_tta,
          creation_channel_activity_id: nil,
          date_of_birth: "1966-03-24",
          preferred_education_phase_id: nil,
          address_postcode: nil,
        })
        expect_sign_up_with_attributes(request_attributes)

        click_on "Complete sign up"

        expect(page).to have_css "h1", text: "John, give us a call"
        expect(page).to have_text "Please give us a call so that we can check your degree"
      end
    end

    scenario "studying for a degree (not final year)" do
      visit teacher_training_adviser_steps_path

      expect(page).to have_css "h1", text: "Get a free adviser"
      fill_in_identity_step
      click_on "Next step"

      expect(page).to have_css "h1", text: "Are you qualified to teach?"
      choose "No"
      click_on "Next step"

      expect(page).to have_css "h1", text: "Do you have a degree?"
      choose "Not yet, I'm studying for one"
      fill_in "Which year will you graduate?", with: "2025"
      click_on "Next step"

      expect(page).to have_css "h1", text: "Which country is your degree from?"
      choose "The UK"
      click_on "Next step"

      expect(page).to have_css "h1", text: "What subject is your degree?"
      fill_in "What subject is your degree?", with: "Mathematics"
      click_on "Next step"

      expect(page).to have_css "h1", text: "How would you describe your current situation?"
      choose "Exploring options for my first career"
      click_on "Next step"

      expect(page).to have_css "h1", text: "Which stage are you most interested in teaching?"
      choose "Secondary"
      click_on "Next step"

      expect(page).to have_css "h1", text: "Select the subject you're most interested in teaching"
      select "Physics"
      click_on "Next step"

      expect(page).to have_css "h1", text: "Enter your date of birth"
      fill_in_date_of_birth_step
      click_on "Next step"

      expect(page).to have_css "h1", text: "Are you a UK citizen?"
      choose "No"
      click_on "Next step"

      expect(page).to have_css "h1", text: "Do you have a visa or immigration status allowing you to train to teach in England?"
      choose "No, I will need to apply for a visa"
      click_on "Next step"

      expect(page).to have_css "h1", text: "Where do you live?"
      choose "Outside of the UK"
      click_on "Next step"

      expect(page).to have_css "h1", text: "Which country do you live in?"
      select "Argentina"
      click_on "Next step"

      expect(page).to have_css "h1", text: "What's your telephone number"
      expect(find_field("Overseas telephone number (optional)").value).to eq "54"
      fill_in "Overseas telephone number (optional)", with: "123456789"
      click_on "Next step"

      expect(page).to have_css "h1", text: "Check your answers before you continue"

      request_attributes = overseas_candidate_request_attributes({
        type_id: INTERESTED_IN_TEACHING,
        degree_status_id: DEGREE_STATUS_IN_PROGRESS,
        degree_type_id: DEGREE_TYPE_DEGREE,
        degree_subject: "Mathematics",
        graduation_year: 2025,
        preferred_education_phase_id: EDUCATION_PHASE_SECONDARY,
        citizenship: CITIZENSHIP_NOT_UK,
        visa_status: VISA_STATUS_WILL_NEED_VISA,
      })
      expect_sign_up_with_attributes(request_attributes)

      click_on "Complete sign up"

      expect(page).to have_css "h1", text: "John, you're signed up."
    end

    scenario "studying for a degree (final year)" do
      visit teacher_training_adviser_steps_path

      expect(page).to have_css "h1", text: "Get a free adviser"
      fill_in_identity_step
      click_on "Next step"

      expect(page).to have_css "h1", text: "Are you qualified to teach?"
      choose "No"
      click_on "Next step"

      expect(page).to have_css "h1", text: "Do you have a degree?"
      choose "Not yet, I'm studying for one"
      fill_in "Which year will you graduate?", with: "2022"
      click_on "Next step"

      expect(page).to have_css "h1", text: "Which country is your degree from?"
      choose "The UK"
      click_on "Next step"

      expect(page).to have_css "h1", text: "What subject is your degree?"
      fill_in "What subject is your degree?", with: "Mathematics"
      click_on "Next step"

      expect(page).to have_css "h1", text: "What degree grade are you predicted to get?"
      choose "Lower second-class honours (2:2)"
      click_on "Next step"

      expect(page).to have_css "h1", text: "How would you describe your current situation?"
      choose "Teaching assistant or unqualified teacher in a school"
      click_on "Next step"

      expect(page).to have_css "h1", text: "Which stage are you most interested in teaching?"
      choose "Primary"
      click_on "Next step"

      expect(page).to have_css "h1", text: "Do you have grade 4 (C) or above in English and maths GCSEs, or equivalent qualifications?"
      choose "Yes"
      click_on "Next step"

      expect(page).to have_css "h1", text: "Do you have grade 4 (C) or above in GCSE science, or an equivalent qualification?"
      choose "Yes"
      click_on "Next step"

      expect(page).to have_css "h1", text: "When do you want to start your teacher training?"
      choose "2022"
      click_on "Next step"

      expect(page).to have_css "h1", text: "Enter your date of birth"
      fill_in_date_of_birth_step
      click_on "Next step"

      expect(page).to have_css "h1", text: "Are you a UK citizen?"
      choose "No"
      click_on "Next step"

      expect(page).to have_css "h1", text: "Do you have a visa or immigration status allowing you to train to teach in England?"
      choose "Yes, I have a visa, pre-settled status or leave to remain"
      click_on "Next step"

      expect(page).to have_css "h1", text: "Where do you live?"
      choose "Outside of the UK"
      click_on "Next step"

      expect(page).to have_css "h1", text: "Which country do you live in?"
      select "Argentina"
      click_on "Next step"

      expect(page).to have_css "h1", text: "What's your telephone number"
      expect(find_field("Overseas telephone number (optional)").value).to eq "54"
      fill_in "Overseas telephone number (optional)", with: "123456789"
      click_on "Next step"

      expect(page).to have_css "h1", text: "Check your answers before you continue"

      request_attributes = overseas_candidate_request_attributes({
        type_id: INTERESTED_IN_TEACHING,
        uk_degree_grade_id: UK_DEGREE_GRADE_2_2,
        degree_status_id: DEGREE_STATUS_IN_PROGRESS,
        graduation_year: 2022,
        degree_type_id: DEGREE_TYPE_DEGREE,
        initial_teacher_training_year_id: TEACHER_TRAINING_YEAR_2022,
        preferred_education_phase_id: EDUCATION_PHASE_PRIMARY,
        has_gcse_maths_and_english_id: HAS_GCSE,
        has_gcse_science_id: HAS_GCSE,
        degree_subject: "Mathematics",
        citizenship: CITIZENSHIP_NOT_UK,
        visa_status: VISA_STATUS_HAVE_VISA,
      })
      expect_sign_up_with_attributes(request_attributes)

      click_on "Complete sign up"

      expect(page).to have_css "h1", text: "John, you're signed up."
    end

    scenario "candidate changes an answer" do
      visit teacher_training_adviser_steps_path

      expect(page).to have_css "h1", text: "Get a free adviser"
      fill_in_identity_step
      click_on "Next step"

      expect(page).to have_css "h1", text: "Are you qualified to teach?"
      choose "Yes"
      click_on "Next step"

      expect(page).to have_css "h1", text: "Do you have a teacher reference number (TRN)?"
      choose "Yes"
      click_on "Next step"

      expect(page).to have_css "h1", text: "What is your teacher reference number (TRN)?"
      fill_in "Teacher reference number (optional)", with: "1234"
      click_on "Next step"

      expect(page).to have_css "h1", text: "Do you have paid teaching experience in the UK of at least one term?"
      choose "Yes"
      click_on "Next step"

      expect(page).to have_css "h1", text: "Which stage did you previously teach?"
      choose "Secondary"
      click_on "Next step"

      expect(page).to have_css "h1", text: "Which main subject did you previously teach?"
      select "Psychology"
      click_on "Next step"

      expect(page).to have_css "h1", text: "Which stage are you most interested in teaching?"
      choose "Secondary"
      click_on "Next step"

      expect(page).to have_css "h1", text: "Which subject would you like to teach if you return to teaching?"
      select "Physics"
      click_on "Next step"

      expect(page).to have_css "h1", text: "Enter your date of birth"
      fill_in_date_of_birth_step
      click_on "Next step"

      expect(page).to have_css "h1", text: "Are you a UK citizen?"
      choose "Yes"
      click_on "Next step"

      expect(page).to have_css "h1", text: "Where do you live?"
      choose "In the UK"
      click_on "Next step"

      expect(page).to have_css "h1", text: "What's your postcode?"
      fill_in_address_step
      click_on "Next step"

      expect(page).to have_css "h1", text: "What's your telephone number?"
      fill_in "UK telephone number (optional)", with: "123456789"
      click_on "Next step"

      expect(page).to have_css "h1", text: "Check your answers before you continue"
      click_on "Change your previous teacher reference number"

      expect(page).to have_css "h1", text: "What is your teacher reference number (TRN)?"
      fill_in "Teacher reference number (optional)", with: "5678"
      click_on "Next step"

      expect(page).to have_css "h1", text: "Check your answers before you continue"

      request_attributes = uk_candidate_request_attributes({
        type_id: RETURNING_TO_TEACHING,
        subject_taught_id: SUBJECT_PSYCHOLOGY,
        preferred_teaching_subject_id: SUBJECT_PHYSICS,
        teacher_id: "5678",
        citizenship: CITIZENSHIP_UK,
      })
      expect_sign_up_with_attributes(request_attributes)

      click_on "Complete sign up"

      expect(page).to have_css "h1", text: "John, you're signed up."
    end

    scenario "candidate is a returning primary teacher" do
      visit teacher_training_adviser_steps_path

      expect(page).to have_css "h1", text: "Get a free adviser"
      fill_in_identity_step
      click_on "Next step"

      expect(page).to have_css "h1", text: "Are you qualified to teach?"
      choose "Yes"
      click_on "Next step"

      expect(page).to have_css "h1", text: "Do you have a teacher reference number (TRN)?"
      choose "Yes"
      click_on "Next step"

      expect(page).to have_css "h1", text: "What is your teacher reference number (TRN)?"
      fill_in "Teacher reference number (optional)", with: "1234"
      click_on "Next step"

      expect(page).to have_css "h1", text: "Do you have paid teaching experience in the UK of at least one term?"
      choose "Yes"
      click_on "Next step"

      expect(page).to have_css "h1", text: "Which stage did you previously teach?"
      choose "Primary"
      click_on "Next step"

      expect(page).to have_css "h1", text: "Which stage are you most interested in teaching?"
      choose "Primary"
      click_on "Next step"

      expect(page).to have_css "h1", text: "Enter your date of birth"
      fill_in_date_of_birth_step
      click_on "Next step"

      expect(page).to have_css "h1", text: "Are you a UK citizen?"
      choose "Yes"
      click_on "Next step"

      expect(page).to have_css "h1", text: "Where do you live?"
      choose "In the UK"
      click_on "Next step"

      expect(page).to have_css "h1", text: "What's your postcode?"
      fill_in_address_step
      click_on "Next step"

      expect(page).to have_css "h1", text: "What's your telephone number?"
      fill_in "UK telephone number (optional)", with: "123456789"
      click_on "Next step"

      expect(page).to have_css "h1", text: "Check your answers before you continue"

      request_attributes = uk_candidate_request_attributes(
        {
          type_id: RETURNING_TO_TEACHING,
          stage_taught_id: EDUCATION_PHASE_PRIMARY,
          preferred_education_phase_id: EDUCATION_PHASE_PRIMARY,
          teacher_id: "1234",
          citizenship: CITIZENSHIP_UK,
        },
      )
      expect_sign_up_with_attributes(request_attributes)

      click_on "Complete sign up"

      expect(page).to have_css "h1", text: "John, you're signed up."
    end

    scenario "without a degree" do
      visit teacher_training_adviser_steps_path

      expect(page).to have_css "h1", text: "Get a free adviser"
      fill_in_identity_step
      click_on "Next step"

      expect(page).to have_css "h1", text: "Are you qualified to teach?"
      choose "No"
      click_on "Next step"

      expect(page).to have_css "h1", text: "Do you have a degree?"
      choose "No"
      click_on "Next step"

      expect(page).to have_css "h1", text: "You need to have or be studying towards a degree to sign up for an adviser"
      expect(page).not_to have_css "h1", text: "Continue"
    end

    scenario "without science GCSEs, primary" do
      visit teacher_training_adviser_steps_path

      expect(page).to have_css "h1", text: "Get a free adviser"
      fill_in_identity_step
      click_on "Next step"

      expect(page).to have_css "h1", text: "Are you qualified to teach?"
      choose "No"
      click_on "Next step"

      expect(page).to have_css "h1", text: "Do you have a degree?"
      choose "Yes"
      click_on "Next step"

      expect(page).to have_css "h1", text: "Which country is your degree from?"
      choose "The UK"
      click_on "Next step"

      expect(page).to have_css "h1", text: "What subject is your degree?"
      fill_in "What subject is your degree?", with: "Mathematics"
      click_on "Next step"

      expect(page).to have_css "h1", text: "What grade is your degree?"
      choose "Lower second-class honours (2:2)"
      click_on "Next step"

      expect(page).to have_css "h1", text: "How would you describe your current situation?"
      choose "Considering changing my existing career"
      click_on "Next step"

      expect(page).to have_css "h1", text: "Which stage are you most interested in teaching?"
      choose "Primary"
      click_on "Next step"

      expect(page).to have_css "h1", text: "Do you have grade 4 (C) or above in English and maths GCSEs, or equivalent qualifications?"
      choose "No"
      click_on "Next step"

      expect(page).to have_css "h1", text: "Are you planning to retake either English or maths (or both) GCSEs, or equivalent qualifications?"
      choose "Yes"
      click_on "Next step"

      expect(page).to have_css "h1", text: "Do you have grade 4 (C) or above in GCSE science, or an equivalent qualification?"
      choose "No"
      click_on "Next step"

      expect(page).to have_css "h1", text: "Are you planning to retake your science GCSE?"
      choose "No"
      click_on "Next step"

      expect(page).to have_css "h1", text: "We're sorry, but you need the right GCSEs to sign up for an adviser"
      expect(page).not_to have_css "h1", text: "Continue"
    end

    scenario "without english/maths GCSEs, primary" do
      visit teacher_training_adviser_steps_path

      expect(page).to have_css "h1", text: "Get a free adviser"
      fill_in_identity_step
      click_on "Next step"

      expect(page).to have_css "h1", text: "Are you qualified to teach?"
      choose "No"
      click_on "Next step"

      expect(page).to have_css "h1", text: "Do you have a degree?"
      choose "Yes"
      click_on "Next step"

      expect(page).to have_css "h1", text: "Which country is your degree from?"
      choose "The UK"
      click_on "Next step"

      expect(page).to have_css "h1", text: "What subject is your degree?"
      fill_in "What subject is your degree?", with: "Mathematics"
      click_on "Next step"

      expect(page).to have_css "h1", text: "What grade is your degree?"
      choose "Lower second-class honours (2:2)"
      click_on "Next step"

      expect(page).to have_css "h1", text: "How would you describe your current situation?"
      choose "Graduated and exploring my career options"
      click_on "Next step"

      expect(page).to have_css "h1", text: "Which stage are you most interested in teaching?"
      choose "Primary"
      click_on "Next step"

      expect(page).to have_css "h1", text: "Do you have grade 4 (C) or above in English and maths GCSEs, or equivalent qualifications?"
      choose "No"
      click_on "Next step"

      expect(page).to have_css "h1", text: "Are you planning to retake either English or maths (or both) GCSEs, or equivalent qualifications?"
      choose "No"
      click_on "Next step"

      expect(page).to have_css "h1", text: "We're sorry, but you need the right GCSEs to sign up for an adviser"
      expect(page).not_to have_css "h1", text: "Continue"
    end

    scenario "without GCSEs, secondary" do
      visit teacher_training_adviser_steps_path

      expect(page).to have_css "h1", text: "Get a free adviser"
      fill_in_identity_step
      click_on "Next step"

      expect(page).to have_css "h1", text: "Are you qualified to teach?"
      choose "No"
      click_on "Next step"

      expect(page).to have_css "h1", text: "Do you have a degree?"
      choose "Yes"
      click_on "Next step"

      expect(page).to have_css "h1", text: "Which country is your degree from?"
      choose "The UK"
      click_on "Next step"

      expect(page).to have_css "h1", text: "What subject is your degree?"
      fill_in "What subject is your degree?", with: "Mathematics"
      click_on "Next step"

      expect(page).to have_css "h1", text: "What grade is your degree?"
      choose "Lower second-class honours (2:2)"
      click_on "Next step"

      expect(page).to have_css "h1", text: "How would you describe your current situation?"
      choose "Not currently working"
      click_on "Next step"

      expect(page).to have_css "h1", text: "Which stage are you most interested in teaching?"
      choose "Secondary"
      click_on "Next step"

      expect(page).to have_css "h1", text: "Do you have grade 4 (C) or above in English and maths GCSEs, or equivalent qualifications?"
      choose "No"
      click_on "Next step"

      expect(page).to have_css "h1", text: "Are you planning to retake either English or maths (or both) GCSEs, or equivalent qualifications?"
      choose "No"
      click_on "Next step"

      expect(page).to have_css "h1", text: "We're sorry, but you need the right GCSEs to sign up for an adviser"
      expect(page).not_to have_css "h1", text: "Continue"
    end
  end

  context "when an existing candidate" do
    let(:valid_code) { "123456" }
    let(:invalid_code) { "111111" }
    let(:existing_candidate) do
      GetIntoTeachingApiClient::TeacherTrainingAdviserSignUp.new(
        preferred_education_phase_id: TeacherTrainingAdviser::Steps::StageInterestedTeaching::OPTIONS[:secondary],
        address_postcode: "TE7 1NG",
        date_of_birth: Date.new(1999, 4, 27),
        address_telephone: "123456789",
        teacher_id: "12345",
      )
    end

    before do
      allow_any_instance_of(GetIntoTeachingApiClient::CandidatesApi).to \
        receive(:create_candidate_access_token)
      allow_any_instance_of(GetIntoTeachingApiClient::TeacherTrainingAdviserApi).to \
        receive(:exchange_access_token_for_teacher_training_adviser_sign_up)
        .with(valid_code, anything)
        .and_return(existing_candidate)
      allow_any_instance_of(GetIntoTeachingApiClient::TeacherTrainingAdviserApi).to \
        receive(:exchange_access_token_for_teacher_training_adviser_sign_up)
        .with(invalid_code, anything)
        .and_raise(GetIntoTeachingApiClient::ApiError)
    end

    scenario "matchback" do
      visit teacher_training_adviser_steps_path

      expect(page).to have_css "h1", text: "Get a free adviser"
      fill_in_identity_step
      click_on "Next step"

      expect(page).to have_css "h1", text: "You're already registered with us"
      expect(page).to have_text "To verify your details, we've sent a code to your email address."
      click_on "Send another code to verify my details"

      expect(page).to have_text "We've sent you another email"
      fill_in "teacher-training-adviser-steps-authenticate-timed-one-time-password-field", with: invalid_code
      click_on "Next step"

      expect(page).to have_text "Please enter the latest verification code sent to your email address"
      fill_in "teacher-training-adviser-steps-authenticate-timed-one-time-password-field-error", with: valid_code
      click_on "Next step"

      expect(page).to have_css "h1", text: "Are you qualified to teach?"
      choose "No"
      click_on "Next step"

      expect(page).to have_css "h1", text: "Do you have a degree?"
      choose "Yes"
      click_on "Next step"

      expect(page).to have_css "h1", text: "Which country is your degree from?"
      choose "Another Country"
      click_on "Next step"

      expect(page).to have_css "h1", text: "Enter your date of birth"
      expect(find_field("Day").value).to eq("27")
      expect(find_field("Month").value).to eq("4")
      expect(find_field("Year").value).to eq("1999")
      click_on "Next step"

      expect(page).to have_css "h1", text: "Where do you live?"
      choose "In the UK"
      click_on "Next step"

      expect(page).to have_css "h1", text: "You need to speak to our team"
      expect(find_field("Your telephone number").value).to eq("123456789")
      # Cause an error to check the time zone is correct on an update action
      fill_in "Your telephone number", with: ""
      click_on "Next step"
      expect(page).to have_text("Enter your telephone number")
      fill_in "Your telephone number", with: "123456789"
      # Select time in local time zone (London)
      select "11:00am to 12:00pm", from: "Your preferred day and time for a callback"
      click_on "Next step"

      expect(page).to have_css "h1", text: "Check your answers before you continue"

      request_attributes = uk_candidate_request_attributes({
        type_id: INTERESTED_IN_TEACHING,
        degree_status_id: DEGREE_STATUS_HAS_DEGREE,
        degree_type_id: DEGREE_TYPE_EQUIVALENT,
        phone_call_scheduled_at: "#{quota.start_at.strftime('%Y-%m-%dT%H:%M:%S')}.000Z",
        address_postcode: "TE7 1NG",
        address_telephone: "123456789",
        accepted_policy_id: "123",
        date_of_birth: "1999-04-27",
      })

      expect_sign_up_with_attributes(request_attributes)

      click_on "Complete sign up"

      expect(page).to have_css "h1", text: "John, we'll give you a call"
    end

    scenario "skipping pre-filled optional steps" do
      visit teacher_training_adviser_steps_path

      expect(page).to have_css "h1", text: "Get a free adviser"
      fill_in_identity_step
      click_on "Next step"

      expect(page).to have_css "h1", text: "You're already registered with us"
      fill_in "teacher-training-adviser-steps-authenticate-timed-one-time-password-field", with: valid_code
      click_on "Next step"

      expect(page).to have_css "h1", text: "Are you qualified to teach?"
      choose "Yes"
      click_on "Next step"

      expect(page).not_to have_css "h1", text: "Do you have your previous teacher reference number?"
      expect(page).not_to have_css "h1", text: "What is your teacher reference number (TRN)?"

      expect(page).to have_css "h1", text: "Do you have paid teaching experience in the UK of at least one term?"
      choose "Yes"
      click_on "Next step"

      expect(page).to have_css "h1", text: "Which stage did you previously teach?"
      choose "Secondary"
      click_on "Next step"

      expect(page).to have_css "h1", text: "Which main subject did you previously teach?"
      select "Psychology"
      click_on "Next step"

      expect(page).to have_css "h1", text: "Which stage are you most interested in teaching?"
      choose "Secondary"
      click_on "Next step"

      expect(page).to have_css "h1", text: "Which subject would you like to teach if you return to teaching?"
      select "Physics"
      click_on "Next step"

      expect(page).to have_css "h1", text: "Enter your date of birth"
      expect(find_field("Day").value).to eq("27")
      expect(find_field("Month").value).to eq("4")
      expect(find_field("Year").value).to eq("1999")
      click_on "Next step"

      expect(page).to have_css "h1", text: "Are you a UK citizen?"
      choose "Yes"
      click_on "Next step"

      expect(page).to have_css "h1", text: "Where do you live?"
      choose "In the UK"
      click_on "Next step"

      expect(page).to have_css "h1", text: "What's your postcode?"
      expect(find_field("What's your postcode?").value).to eq("TE7 1NG")
      click_on "Next step"

      expect(page).not_to have_css "h1", text: "What's your telephone number?"

      expect(page).to have_css "h1", text: "Check your answers before you continue"

      request_attributes = uk_candidate_request_attributes({
        subject_taught_id: SUBJECT_PSYCHOLOGY,
        preferred_teaching_subject_id: SUBJECT_PHYSICS,
        date_of_birth: "1999-04-27",
        address_postcode: "TE7 1NG",
        teacher_id: "12345",
        citizenship: CITIZENSHIP_UK,
      })
      expect_sign_up_with_attributes(request_attributes)

      click_on "Complete sign up"

      expect(page).to have_css "h1", text: "John, you're signed up."
    end
  end

  def fill_in_identity_step
    fill_in "First name", with: "John"
    fill_in "Last name", with: "Doe"
    fill_in "Email address", with: "john@doe.com"
  end

  def fill_in_date_of_birth_step
    fill_in "Day", with: "24"
    fill_in "Month", with: "03"
    fill_in "Year", with: "1966"
  end

  def fill_in_address_step
    fill_in "What's your postcode?", with: "EH12 8JF"
  end

  def expect_sign_up_with_attributes(request_attributes)
    expect_any_instance_of(GetIntoTeachingApiClient::TeacherTrainingAdviserApi).to \
      receive(:sign_up_teacher_training_adviser_candidate)
      .with(having_attributes(request_attributes))
      .once
  end

  def uk_candidate_request_attributes(attributes = {})
    {
      email: "john@doe.com",
      first_name: "John",
      last_name: "Doe",
      date_of_birth: "1966-03-24",
      address_postcode: "EH12 8JF",
      country_id: "72f5c2e6-74f9-e811-a97a-000d3a2760f2",
      accepted_policy_id: "123",
      preferred_education_phase_id: EDUCATION_PHASE_SECONDARY,
    }
    .merge(shared_request_attributes)
    .merge(attributes)
  end

  def overseas_candidate_request_attributes(attributes = {})
    {
      country_id: "09f4c2e6-74f9-e811-a97a-000d3a2760f2",
      accepted_policy_id: "123",
    }
    .merge(shared_request_attributes)
    .merge(attributes)
  end

  def shared_request_attributes
    {
      email: "john@doe.com",
      first_name: "John",
      last_name: "Doe",
      date_of_birth: "1966-03-24",
      address_telephone: "123456789",
    }
  end
end
