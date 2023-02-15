require "rails_helper"

RSpec.feature "Mailing list wizard", type: :feature do
  include_context "with wizard data"
  include_context "with stubbed latest privacy policy api"
  include_context "with stubbed callback quotas api"

  let(:mailing_list_page_title) { "Get tailored guidance in your inbox | Get Into Teaching GOV.UK" }

  scenario "Full journey as a new candidate" do
    allow_any_instance_of(GetIntoTeachingApiClient::CandidatesApi).to \
      receive(:create_candidate_access_token).and_raise(GetIntoTeachingApiClient::ApiError)

    visit mailing_list_steps_path

    expect(page).to have_title(mailing_list_page_title)

    expect(page).to have_text "Get guidance around teacher training in your inbox"
    fill_in_name_step
    click_on "Next step"

    expect(page).not_to have_text "Tell us more about you so that you only get emails relevant to your circumstances."

    expect(page).to have_text "Do you have a degree?"
    choose "Not yet, I'm a first year student"
    click_on "Next step"

    expect(page).to have_text "How close are you to applying"
    choose "I'm not sure and finding out more"
    click_on "Next step"

    expect(page).to have_text "Which subject do you want to teach"
    select "Maths"
    click_on "Next step"

    expect(page).to have_text "If you give us your postcode"
    fill_in "Your postcode (optional)", with: "TE57 1NG"
    click_on "Complete sign up"

    expect(page).to have_title("You've signed up | Get Into Teaching")
    expect(page).to have_text "You've signed up"
    expect(page).to have_text("You'll receive a welcome email shortly")
    expect(page).to have_link("Book a callback")
  end

  scenario "Full journey as an on-campus candidate" do
    sub_channel_id = "abc123"

    allow_any_instance_of(GetIntoTeachingApiClient::CandidatesApi).to \
      receive(:create_candidate_access_token).and_raise(GetIntoTeachingApiClient::ApiError)

    channel_id = channels.first.id
    visit mailing_list_steps_path({ id: :name, channel: channel_id, sub_channel: sub_channel_id })

    expect(page).to have_text "Get guidance around teacher training in your inbox"
    # Error to ensure channel/sub-channel persists over page reload.
    click_on "Next step"
    expect(page).to have_text("Enter your full email address")
    fill_in_name_step
    click_on "Next step"

    expect(page).to have_text "Do you have a degree?"
    choose "Not yet, I'm a first year student"
    click_on "Next step"

    expect(page).to have_text "How close are you to applying"
    choose "I'm not sure and finding out more"
    click_on "Next step"

    expect(page).to have_text "Which subject do you want to teach"
    select "Maths"
    click_on "Next step"

    expect(page).to have_text "If you give us your postcode"
    fill_in "Your postcode (optional)", with: "TE57 1NG"
    click_on "Complete sign up"

    expect(page).to have_text "You've signed up"
    expect(page).to have_text("You'll receive a welcome email shortly")

    # We pass this to the BAM tracking pixel in GTM.
    expect(page).to have_selector("[data-sub-channel-id='#{sub_channel_id}']")
  end

  scenario "Full journey as an on-campus candidate that qualifies for the welcome guide" do
    sub_channel_id = "abc123"

    allow_any_instance_of(GetIntoTeachingApiClient::CandidatesApi).to \
      receive(:create_candidate_access_token).and_raise(GetIntoTeachingApiClient::ApiError)

    channel_id = channels.first.id
    visit mailing_list_steps_path({ id: :name, channel: channel_id, sub_channel: sub_channel_id })

    expect(page).to have_text("Get guidance around teacher training in your inbox")
    fill_in_name_step
    click_on "Next step"

    expect(page).to have_text "Do you have a degree?"
    choose "Almost, I'm a final year student"
    click_on "Next step"

    expect(page).to have_text "How close are you to applying"
    choose "I'm not sure and finding out more"
    click_on "Next step"

    expect(page).to have_text "Which subject do you want to teach"
    select "Maths"
    click_on "Next step"

    expect(page).to have_text "If you give us your postcode"
    fill_in "Your postcode (optional)", with: "TE57 1NG"
    click_on "Complete sign up"

    expect(page).to have_text "Test, you're signed up"
    expect(page).to have_link("Continue your journey")

    # We pass this to the BAM tracking pixel in GTM.
    expect(page).to have_selector("[data-sub-channel-id='#{sub_channel_id}']")
  end

  scenario "Full journey as an on-campus candidate (invalid channel_id)" do
    sub_channel_id = "abc123"

    allow_any_instance_of(GetIntoTeachingApiClient::CandidatesApi).to \
      receive(:create_candidate_access_token).and_raise(GetIntoTeachingApiClient::ApiError)

    visit mailing_list_steps_path({ id: :name, channel: "invalid", sub_channel: sub_channel_id })

    expect(page).to have_text "Get guidance around teacher training in your inbox"
    fill_in_name_step
    click_on "Next step"

    expect(page).to have_text "Do you have a degree?"
    choose "Not yet, I'm a first year student"
    click_on "Next step"

    expect(page).to have_text "How close are you to applying"
    choose "I'm not sure and finding out more"
    click_on "Next step"

    expect(page).to have_text "Which subject do you want to teach"
    select "Maths"
    click_on "Next step"

    expect(page).to have_text "If you give us your postcode"
    fill_in "Your postcode (optional)", with: "TE57 1NG"
    click_on "Complete sign up"

    expect(page).to have_text "You've signed up"
    expect(page).to have_text("You'll receive a welcome email shortly")
  end

  scenario "Full journey as an existing candidate" do
    first_name = "Joey"

    allow_any_instance_of(GetIntoTeachingApiClient::CandidatesApi).to \
      receive(:create_candidate_access_token)

    response = GetIntoTeachingApiClient::MailingListAddMember.new(
      preferred_teaching_subject_id: TeachingSubject.lookup_by_key(:maths),
      consideration_journey_stage_id: OptionSet.lookup_by_key(:consideration_journey_stage, :i_m_very_sure_and_think_i_ll_apply),
      degree_status_id: OptionSet.lookup_by_key(:degree_status, :final_year),
      address_postcode: "TE57 1NG",
    )
    allow_any_instance_of(GetIntoTeachingApiClient::MailingListApi).to \
      receive(:exchange_access_token_for_mailing_list_add_member).with("123456", anything) { response }

    visit mailing_list_steps_path

    expect(page).to have_text "Get guidance around teacher training in your inbox"
    fill_in_name_step(first_name: first_name)
    click_on "Next step"

    expect(page).to have_text "You're already registered with us"
    fill_in "To verify your details, we've sent a code to your email address.", with: "123456"
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
      selected: TeachingSubject.lookup_by_uuid(response.preferred_teaching_subject_id),
    )
    click_on "Complete sign up"

    expect(page).to have_text "#{first_name}, you're signed up"
    expect(page).to have_text("We'll send your first email shortly")
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

    expect(page).to have_text "Get guidance around teacher training in your inbox"
    fill_in_name_step
    click_on "Next step"

    expect(page).to have_text "You're already registered with us"
    fill_in "To verify your details, we've sent a code to your email address.", with: "654321"
    click_on "Next step"

    expect(page).to have_text "Please enter the latest verification code"

    click_link "Send another code to verify my details."
    expect(page).to have_text "We've sent you another email"

    fill_in "To verify your details, we've sent a code to your email address.", with: "123456"
    click_on "Next step"

    expect(page).to have_text "Do you have a degree?"
  end

  scenario "Full journey as an existing candidate that has already subscribed to the mailing list" do
    allow_any_instance_of(GetIntoTeachingApiClient::CandidatesApi).to \
      receive(:create_candidate_access_token)

    response = GetIntoTeachingApiClient::MailingListAddMember.new(
      already_subscribed_to_mailing_list: true,
    )
    allow_any_instance_of(GetIntoTeachingApiClient::MailingListApi).to \
      receive(:exchange_access_token_for_mailing_list_add_member).with("123456", anything).and_return(response)

    visit mailing_list_steps_path

    expect(page).to have_text "Get guidance around teacher training in your inbox"
    fill_in_name_step
    click_on "Next step"

    expect(page).to have_text "You're already registered with us"
    fill_in "To verify your details, we've sent a code to your email address.", with: "123456"
    click_on "Next step"

    expect(page).to have_text "You've already signed up"
    expect(page).not_to have_button("Next step")
  end

  scenario "Full journey as an existing candidate that has already subscribed to a teacher training adviser" do
    allow_any_instance_of(GetIntoTeachingApiClient::CandidatesApi).to \
      receive(:create_candidate_access_token)

    response = GetIntoTeachingApiClient::MailingListAddMember.new(
      already_subscribed_to_teacher_training_adviser: true,
    )
    allow_any_instance_of(GetIntoTeachingApiClient::MailingListApi).to \
      receive(:exchange_access_token_for_mailing_list_add_member).with("123456", anything).and_return(response)

    visit mailing_list_steps_path

    expect(page).to have_text "Get guidance around teacher training in your inbox"
    fill_in_name_step
    click_on "Next step"

    expect(page).to have_text "You're already registered with us"
    fill_in "To verify your details, we've sent a code to your email address.", with: "123456"
    click_on "Next step"

    expect(page).to have_text "Do you have a degree?"
  end

  scenario "Full journey as an existing candidate using a magic link" do
    token = "magic-link-token"
    response = GetIntoTeachingApiClient::MailingListAddMember.new(
      first_name: "Test",
      last_name: "User",
      email: "test@user.com",
      consideration_journey_stage_id: OptionSet.lookup_by_key(:consideration_journey_stage, :i_m_very_sure_and_think_i_ll_apply),
      degree_status_id: OptionSet.lookup_by_key(:degree_status, :final_year),
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

    expect(page).to have_text "If you give us your postcode"
    fill_in "Your postcode (optional)", with: ""
    click_on "Complete sign up"

    expect(page).to have_text "You've signed up"
    expect(page).to have_text("We'll send your first email shortly")
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
      already_subscribed_to_mailing_list: true,
    )
    allow_any_instance_of(GetIntoTeachingApiClient::MailingListApi).to \
      receive(:exchange_access_token_for_mailing_list_add_member).with("123456", anything).and_return(response)

    visit mailing_list_steps_path

    expect(page).to have_text "Get guidance around teacher training in your inbox"
    fill_in_name_step
    click_on "Next step"

    expect(page).to have_text "You're already registered with us"
    fill_in "To verify your details, we've sent a code to your email address.", with: "123456"
    click_on "Next step"

    expect(page).to have_text "You've already signed up"
    click_link("Back")

    expect(page).to have_text "You're already registered with us"
    click_link("Back")

    allow_any_instance_of(GetIntoTeachingApiClient::CandidatesApi).to \
      receive(:create_candidate_access_token).and_raise(GetIntoTeachingApiClient::ApiError)

    expect(page).to have_text "Get guidance around teacher training in your inbox"
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

  context "when there are no callback slots available" do
    let(:quotas) { [] }

    scenario "Viewing the completion page" do
      visit mailing_list_step_path(:completed)

      expect(page).to have_text("You've signed up")
      expect(page).not_to have_link("Book a callback")
    end
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
end
