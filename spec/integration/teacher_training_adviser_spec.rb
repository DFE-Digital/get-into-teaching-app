require "rails_helper"

RSpec.describe "Teacher Training Adviser integration tests", :integration, :mechanize, type: :feature do
  before do
    config_capybara

    visit teacher_training_adviser_steps_path
    click_link "Accept all cookies"
  end

  around do |example|
    WebMock.enable_net_connect!
    example.run
    WebMock.disable_net_connect!(allow_localhost: true)
  end

  it "Full journey as a new candidate" do
    submit_personal_details(rand_first_name, rand_last_name, rand_email)
    complete_sign_up
    expect(page).to have_text(/(we'll give you a call)|(Please give us a call)/i)
  end

  it "Full journey as an existing candidate" do
    email = "ttauser@mailsac.com"
    submit_personal_details(rand_first_name, rand_last_name, email)

    submit_code(email)

    expect_current_step(:returning_teacher)
  end

  def complete_sign_up
    submit_label_step("No", :returning_teacher)
    submit_label_step("Yes", :degree_status)
    submit_label_step("Another country", :degree_country)
    submit_date_of_birth_step(Date.new(1974, 3, 16))
    submit_label_step("UK", :uk_or_overseas)
    submit_uk_callback_step("123456789")
    submit_review_answers_step
  end
end
