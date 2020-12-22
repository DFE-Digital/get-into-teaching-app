require "rails_helper"

describe Content::LinkBlockComponent, type: "component" do
  let(:title) { "Some title" }
  let(:links) { 1.upto(3).map { |i| %(<a href="/page-#{i}">Link #{i}</a>).html_safe } }

  subject! { render_inline(Content::LinkBlockComponent.new(title: title, links: links)) }

  describe "rendering the link block" do
    specify { expect(page).to have_css(".link-block") }

    describe "title" do
      specify "is present" do
        expect(page).to have_css(".link-block__header > h2", text: title)
      end

      specify "has an icon" do
        expect(page).to have_css(".link-block__header > .link-block__header__icon")
      end
    end

    describe "links" do
      specify "are all present" do
        expect(page).to have_css(".link-block__list__item .link-block__list__link a", count: links.size)

        1.upto(3).each { |i| expect(page).to have_link("Link #{i}", href: "/page-#{i}") }
      end

      specify "each one has an icon" do
        expect(page).to have_css(".link-block__list__item .link-block__list__icon", count: links.size)
      end
    end
  end
end
