require "rails_helper"

RSpec.feature "Event sign up", :integration, type: :feature, js: true do
  let(:event_selector) { ".events-featured__list__item" }

  before do
    config_capybara
    navigate_to_last_page_of_events
  end

  around do |example|
    WebMock.enable_net_connect!
    example.run
    WebMock.disable_net_connect!(allow_localhost: true)
  end

  scenario "Full journey as a new candidate" do
    return unless an_event_exists?

    navigate_to_last_event_sign_up
    sign_up(rand_first_name, rand_last_name, rand_email)
  end

  scenario "Full journey as a new candidate (including mailing list step)" do
    return unless an_event_exists?

    navigate_to_last_event_sign_up
    sign_up(rand_first_name, rand_last_name, rand_email, mailing_list: true)
  end

  scenario "Full journey as an existing candidate" do
    return unless an_event_exists?

    navigate_to_last_event_sign_up
    email = "eventsignupuser@mailsac.com"
    submit_personal_details(rand_first_name, rand_last_name, email)

    submit_code(email)

    within_fieldset "Are you over 16 and do you agree" do
      click_label "Yes"
    end

    click_on "Complete sign up"
  end

  def sign_up(_first_name, _last_name, email, mailing_list: false)
    submit_personal_details(rand_first_name, rand_last_name, email)

    fill_in "What is your telephone number? (optional)", with: "01234567890"
    click_on "Next step"

    within_fieldset "Are you over 16 and do you agree" do
      click_label "Yes"
    end

    within_fieldset "Would you like to receive email updates" do
      click_label mailing_list ? "Yes" : "No"
    end

    if mailing_list
      click_on "Next step"
      complete_mailing_list_sign_up
    end

    click_on "Complete sign up"

    expect(page).to have_text("Sign up complete")
  end

  def complete_mailing_list_sign_up
    select "Final year"
    select "It’s just an idea"
    fill_in "What is your postcode? (optional)", with: "TE5 1NG"
    select "Maths"
  end

  def an_event_exists?
    page.has_css?(event_selector)
  end

  def navigate_to_last_event_sign_up
    all(event_selector).last.click
    first("a", text: "Sign up for this event").click
  end

  def navigate_to_last_page_of_events
    visit event_category_path("train-to-teach-events")
    click_link "Accept all cookies"

    if page.has_css?(".pagination")
      all(".pagination .page a").last.click
    end
  end
end
