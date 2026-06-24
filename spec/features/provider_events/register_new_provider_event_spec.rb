require "rails_helper"

RSpec.feature "Register a new provider event", type: :feature do
  include_context "with wizard data"


  around do |example|
    travel_to(Date.new(2026, 6, 24)) do
      example.run
    end
  end


end
