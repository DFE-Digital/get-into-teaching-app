require "rails_helper"

describe HeaderComponent, type: "component" do
  subject! { render_inline(described_class.new) }

  let(:front_matter) do
    { title: "What a nice page", image: "media/images/content/hero-images/0012.jpg" }
  end

  specify "renders a skiplink container" do
    expect(page).to have_css("#skiplink-container")
  end

  specify "renders a covid banner" do
    expect(page).to have_css(".covid .covid__header", text: /Find out how coronavirus is affecting/)
  end

  specify "renders the navigation" do
    expect(page).to have_css("nav > ol.primary")
  end

  specify "doesn't render breadcrumbs by default" do
    expect(page).not_to have_css(".breadcrumb")
  end

  specify "doesn't render hero by default" do
    expect(page).not_to have_css(".hero")
  end

  context "when breadcrumbs: true" do
    subject! { render_inline(described_class.new(breadcrumbs: true)) }

    specify "renders the breadcrumbs" do
      expect(page).to have_css(".breadcrumbs")
    end
  end

  context "when the hero slot is called with valid front matter" do
    subject! do
      render_inline(described_class.new) do |component|
        component.hero(front_matter)
      end
    end

    specify "renders the hero" do
      expect(page).to have_css(".hero")
    end
  end

  context "when content is added above the hero" do
    let(:above_hero_content) { "some above hero content" }

    subject! do
      render_inline(described_class.new) do |component|
        component.above_hero { above_hero_content }
        component.hero(front_matter)
      end
    end

    specify "the content is rendered in the output" do
      expect(page).to have_content(above_hero_content)
    end
  end
end
