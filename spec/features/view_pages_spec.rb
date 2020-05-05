require "rails_helper"

RSpec.feature "View pages", type: :feature do
  scenario "Navigate to home" do
    visit root_path

    expect(page).to have_text("Lorem")
  end
end
