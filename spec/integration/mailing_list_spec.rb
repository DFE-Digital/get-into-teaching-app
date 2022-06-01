require "rails_helper"

RSpec.feature "Mailing list sign up", :integration, type: :feature, js: true do
  before { config_capybara }

  around do |example|
    WebMock.enable_net_connect!
    example.run
    WebMock.disable_net_connect!(allow_localhost: true)
  end

  scenario "Full journey as a new candidate" do
    visit mailing_list_steps_path
    click_link "Accept all cookies"
    sign_up(rand_first_name, rand_last_name, rand_email)
  end

  scenario "Full journey as an existing candidate" do
    visit mailing_list_steps_path
    click_link "Accept all cookies"

    email = "mailinglistuser@mailsac.com"
    submit_personal_details(rand_first_name, rand_last_name, email)

    submit_code(email)

    expect(page).to have_text("You've already signed up")
  end

  scenario "Booking a callback on completion of the mailing list sign up" do
    visit callbacks_steps_path
    click_link "Accept all cookies"

    email = "mailinglistuser@mailsac.com"
    submit_personal_details(rand_first_name, rand_last_name, email)

    click_on "Send another code to verify my details."
    expect(page).to have_text("We've sent you another email")

    submit_code(email)

    fill_in "Phone number", with: "1234567890"
    click_on "Next step"

    select "Eligibility to become a teacher"
    click_on "Next step"

    expect(page).to have_text("Accept privacy policy")
    click_label "Yes"

    click_on "Book your callback"
    expect(page).to have_text("Callback confirmed")
  end

  def sign_up(first_name, last_name, email)
    submit_personal_details(first_name, last_name, email)

    expect(page).to have_text("Do you have a degree?")
    click_label "Yes, I already have a degree"
    click_on "Next step"

    expect(page).to have_text("How close are you to applying for teacher training?")
    click_label "I’m not sure and finding out more"
    click_on "Next step"

    expect(page).to have_text "Which subject do you want to teach?"
    select "Chemistry"
    click_on "Next step"

    expect(page).to have_text "If you give us your postcode"
    fill_in "Your postcode (optional)", with: "TE57 1NG"
    click_on "Next step"

    expect(page).to have_text("Accept privacy policy")
    click_label "Yes"
    click_on "Complete sign up"

    expect(page).to have_text("you're signed up")
  end
end
