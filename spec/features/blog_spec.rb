require "rails_helper"

describe "reading the blog", type: :feature do
  let(:tag) { Pages::Blog.popular_tags(1).first }

  scenario "browsing to a popular tag" do
    visit blog_index_path

    expect(page).to have_css(".blog-tags")

    first("aside .blog-tags").click_link(tag)

    expect(page).to have_current_path("/blog/tag/#{tag.parameterize}")

    expect(page).to have_content("Blog posts about #{tag}")
  end

  shared_examples "paginating blog posts" do |path, count, next_page|
    scenario "paginating blog posts on the #{path} path" do
      visit path

      expect(all(".blog-article").count).to eq(count)

      next unless next_page

      within ".pagination" do
        expect(find(".page.current")).to have_text("1")
        click_on("2")
      end

      expect(current_url).to end_with("?page=2")

      within ".pagination" do
        expect(find(".page.current")).to have_text("2")
      end
    end
  end

  include_context "paginating blog posts", "/blog", 9, false

  scenario "viewing a post" do
    path = "my-career-change-to-teaching"
    fm = Pages::Frontmatter.list.fetch("/blog/#{path}")
    visit blog_path(path)

    expect(page).to have_css("h1", text: fm["title"])
    expect(page).to have_content("I always wanted to be a teacher")

    fm[:tags].all? { |tag| expect(page).to have_css("ol.blog-tags > li", text: tag) }

    # ensure we're pulling in and including the generic closing paragraph named in the front matter
    expect(page).to have_css("article > p:last-of-type", text: "If you’re interested in enriching the lives")
  end

  context "when a blog post has invalid tags" do
    scenario "viewing - do not display content errors" do
      allow(Rails.application.config.x).to receive(:display_content_errors).and_return(false)

      expect { visit blog_path("post_invalid_tag") }.to raise_error(Pages::ContentError)
    end

    scenario "viewing - display content errors" do
      allow(Rails.application.config.x).to receive(:display_content_errors).and_return(true)

      visit blog_path("post_invalid_tag")

      expect(page).to have_http_status(:success)
      expect(page).to have_text("These tags are not defined in tags.yml: invalid tag")
    end
  end
end
