require "rails_helper"

RSpec.feature "Chat", type: :feature do
  include_context "when requesting a page with the Get Into Teaching events badge"

  context "when javascript is enabled", :js do
    scenario "test" do
      puts "TEST 1"
      visit root_path
      puts "TEST 2"
    end
  end
end
