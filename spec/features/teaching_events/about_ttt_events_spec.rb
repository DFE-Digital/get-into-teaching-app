require "rails_helper"

RSpec.feature "About TTT events", type: :feature do
  scenario "there is a link to a pre-filtered page" do
    visit about_ttt_events_path
    expect(page).to have_link("Register for a Train to Teach event", href: events_path("teaching_events_search[type][]" => "ttt,tttqt"))
  end
end
