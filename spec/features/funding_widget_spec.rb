require "rails_helper"

RSpec.feature "Searching for funding options", type: :feature do
  before { visit "/funding-and-support/scholarships-and-bursaries" }

  context "when javascript is disabled" do
    scenario "Submits the form when clicking the 'See funding' button" do
      page.select("Biology", from: "funding_widget_subject")
      find("button", text: "See funding").click

      expect(page).to have_css "h3", text: "Biology - Secondary"
    end

    scenario "The submitted subject is pre-selected" do
      page.select("Biology", from: "funding_widget_subject")
      find("button", text: "See funding").click

      expect(page).to have_select("funding_widget_subject", selected: "Biology")
    end

    scenario "Displays validation errors" do
      find("form button", visible: false).click

      expect(page).to have_text("Select a subject")
      expect(page).to have_css ".form__field--error"
    end
  end

  context "when javascript is enabled" do
    scenario "Submits the form when selecting a subject", js: true do
      click_on "Accept all cookies"
      page.select("Biology", from: "funding_widget_subject")

      expect(page).to have_css "h3", text: "Biology - Secondary"
    end
  end
end
