require "rails_helper"

describe HeaderComponent, type: "component" do
  subject! { render_inline(described_class.new) }

  specify "renders a skiplink container" do
    expect(page).to have_css("#skiplink-container")
  end

  specify "renders a covid banner" do
    expect(page).to have_css(".covid .covid__header", text: /Find out how coronavirus is affecting/)
  end

  specify "renders the navigation" do
    expect(page).to have_css(".navbar")
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
      expect(page).to have_css(".breadcrumb")
    end
  end

  context "when the hero slot is called with valid front matter" do
    let(:front_matter) do
      { title: "What a nice page", image: "media/images/content/hero-images/0012.jpg" }
    end

    subject! do
      render_inline(described_class.new) do |component|
        component.hero(front_matter)
      end
    end

    specify "renders the hero" do
      expect(page).to have_css(".hero")
    end
  end
end
