require "rails_helper"

RSpec.feature "View pages", type: :feature do
  scenario "Navigate to home" do
    visit "/"

    expect(page).to have_css('p', text: "Lorem")
  end
end
