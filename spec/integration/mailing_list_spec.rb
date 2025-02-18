require "rails_helper"

RSpec.feature "Mailing List Integration tests", :integration, :mechanize, type: :feature do
  before { config_capybara }

  around do |example|
    WebMock.enable_net_connect!
    example.run
    WebMock.disable_net_connect!(allow_localhost: true)
  end

  it "Sign up journey as a new candidate" do
    visit mailing_list_steps_path
    click_link "Accept all cookies"
    sign_up(rand_first_name, rand_last_name, rand_email)
    expect(page).to have_text("you're signed up")
  end

  it "Sign up journey as a new candidate if not qualified" do
    visit mailing_list_steps_path
    click_link "Accept all cookies"
    sign_up_if_not_qualified(rand_first_name, rand_last_name, rand_another_email)
    expect(page).to have_text("you're signed up")
  end

  it "Sign up journey as an existing candidate" do
    visit mailing_list_steps_path
    click_link "Accept all cookies"

    email = "mailinglistuser@mailsac.com"
    submit_personal_details(rand_first_name, rand_last_name, email)

    submit_code(email)

    expect(page).to have_text("You've already signed up")
  end

  def sign_up(first_name, last_name, email)
    submit_personal_details(first_name, last_name, email)

    expect(page).to have_text "Are you already qualified to teach?"
    # I'm not sure why 'choose "No"' doesn't work here.
    find("label", text: "No").click
    click_on "Next step"

    expect(page).to have_text("Do you have a degree?")
    click_label "Yes, I already have a degree"
    click_on "Next step"

    expect(page).to have_text("How interested are you in applying for teacher training?")
    click_label "It’s just an idea"
    click_on "Next step"

    expect(page).to have_text "Select the subject you're most interested in teaching"
    select "Chemistry"
    click_on "Next step"

    expect(page).to have_text "We'll only use this to send you information about events happening near you"
    fill_in "What's your UK postcode? (optional)", with: "TE57 1NG"
    click_on "Complete sign up"

    expect(page).to have_text("you're signed up")
  end

  def sign_up_if_not_qualified(first_name, last_name, email)
    submit_personal_details(first_name, last_name, email)

    if page.body.include?("There is a problem") && page.body.include?("Enter your last name")
      # very rarely, for reasons unknown, the test returns an error indicating the last_name is empty. In this case, try and fill it in again.
      Rails.logger.warn("Integration test failed to set last_name correctly; re-setting with: #{last_name}")
      fill_in "Last name", with: last_name
      click_on "Next step"
    end

    expect(page).to have_text "Are you already qualified to teach?"
    find("label", text: "No").click
    click_on "Next step"

    expect(page).to have_text "Do you have a degree?"
    click_label "Not yet, I'm a first year student"
    click_on "Next step"

    expect(page).to have_text("How interested are you in applying")
    click_label "It’s just an idea"
    click_on "Next step"

    expect(page).to have_text("Select the subject you're most interested in teaching")
    select "Maths"
    click_on "Next step"

    expect(page).to have_text "We'll only use this to send you information about events happening near you"
    fill_in "What's your UK postcode? (optional)", with: "TE57 1NG"
    click_on "Complete sign up"

    expect(page).to have_text("you're signed up")
  end
end
