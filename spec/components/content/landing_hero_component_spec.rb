require "rails_helper"

RSpec.describe Content::LandingHeroComponent, type: "component" do
  subject! { Capybara.string(component) }

  let(:image_path) { "static/images/content/hero-images/0001.jpg" }
  let(:title) { "My page" }
  let(:colour) { nil }
  let(:component) do
    render_inline(described_class.new(
                    title: title,
                    colour: colour,
                    image: image_path,
                  ))
  end

  it { is_expected.to have_css(".landing-hero") }
  it { is_expected.to have_css("header") }
  it { is_expected.to have_css("h1", text: "My page") }
  it { is_expected.to have_css(%(img)) }

  context "when the heading text is provided as an array" do
    let(:title) { ["My super", "fancy page"] }

    specify "renders all parts of the array in separate spans within the h1" do
      expect(page).to have_css("h1 > span", text: title.first)
      expect(page).to have_css("h1 > span", text: title.last)
    end
  end

  context "when the colour is overridden" do
    let(:colour) { "purple" }

    it { is_expected.to have_css("header.purple") }
  end
end
