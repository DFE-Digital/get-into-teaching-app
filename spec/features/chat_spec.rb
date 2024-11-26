require "rails_helper"

RSpec.feature "Chat", type: :feature do
  include_context "when requesting a page with the Get Into Teaching events badge"

  context "when javascript is enabled", :js do
    before do
      allow(ENV).to receive(:fetch).and_call_original
      allow(ENV).to receive(:fetch).with("CHAT_AVAILABILITY_API", nil).and_return("http://api.example/")
      stub_request(:get, "http://api.example/")
        .to_return(status: 200, body: "{\"skillid\": 123456, \"available\": false, \"status_age\": 123 }")
    end

    scenario "test" do
      puts "TEST 1"
      visit root_path
      puts "TEST 2"
    end
  end
end
