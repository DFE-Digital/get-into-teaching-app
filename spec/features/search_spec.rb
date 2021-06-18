require "rails_helper"

RSpec.feature "Internal search without JavaScript", type: :feature do
  let(:search_term) do
    Pages::Frontmatter
      .list
      .values
      .detect { |v| v.key?(:keywords) }
      .fetch(:keywords)
      .first
  end

  specify "searching yields results" do
    visit "/search"
    fill_in "Enter your search term", with: search_term
    within("form") { click_on "Search" }

    expect(page).to have_css(".search-result", minimum: 1)
  end
end
