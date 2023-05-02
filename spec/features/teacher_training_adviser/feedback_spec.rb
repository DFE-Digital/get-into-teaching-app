require "rails_helper"

RSpec.feature "Feedback", type: :feature do
  scenario "submitting feedback" do
    visit new_teacher_training_adviser_feedback_path

    choose "No"
    fill_in "Give details", with: "I didn't like it"
    choose "Satisfied"
    fill_in "How could we improve the service? (optional)", with: "You could to better"

    click_on "Submit feedback"

    expect(page).to have_text "Thank you"
  end

  scenario "a bot submitting feedback (filling in the honeypot)" do
    visit new_teacher_training_adviser_feedback_path

    choose "Yes"
    choose "Satisfied"
    fill_in "If you are a human, ignore this field", with: "i-am-a-bot"

    click_on "Submit feedback"

    expect(page.status_code).to eq(200)
    expect(page.body).not_to have_text("Thank you")
  end

  scenario "exporting feedback" do
    visit teacher_training_adviser_feedbacks_path

    feedback = create(:feedback)

    within "form > .govuk-grid-row > .govuk-grid-column-one-third:first-of-type" do
      fill_in "Day", with: feedback.created_at.day
      fill_in "Month", with: feedback.created_at.month
      fill_in "Year", with: feedback.created_at.year
    end

    within "form > .govuk-grid-row > .govuk-grid-column-one-third:last-of-type" do
      fill_in "Day", with: feedback.created_at.day
      fill_in "Month", with: feedback.created_at.month
      fill_in "Year", with: feedback.created_at.year
    end

    click_on "Export CSV"

    expect(page.body).to eq(
      <<~CSV,
        id,rating,successful_visit,unsuccessful_visit_explanation,improvements,created_at
        #{feedback.id},satisfied,true,"","",#{feedback.created_at}
      CSV
    )
  end
end
