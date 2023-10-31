require "rails_helper"

RSpec.feature "Feedback", type: :feature do
  scenario "exporting feedback" do
    visit feedbacks_path

    feedback = create(:user_feedback)

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
        id,topic,rating,explanation,created_at
        #{feedback.id},website,very_satisfied,TEST EXPLANATION,#{feedback.created_at}
      CSV
    )
  end
end
