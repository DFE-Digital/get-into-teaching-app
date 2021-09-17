require "rails_helper"

describe "reading the blog", type: :feature do
  let(:tag) { Pages::Blog.popular_tags(1).first }

  scenario "browsing to a popular tag" do
    visit "/blog"

    expect(page).to have_css(".blog-tags-list")

    click_link(tag)

    expect(page).to have_current_path("/blog/tag/#{tag.parameterize}")

    expect(page).to have_content("Blog posts about #{tag}")
  end
end
