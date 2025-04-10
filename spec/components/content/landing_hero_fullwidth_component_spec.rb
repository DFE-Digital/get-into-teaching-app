require "rails_helper"

RSpec.describe Content::LandingHeroFullwidthComponent, type: "component" do
  subject! { Capybara.string(component) }

  let(:image_path) { "static/images/content/hero-images/celebration.png" }
  let(:component) do
    render_inline(described_class.new(image: image_path))
  end

  it { is_expected.to have_css(".landing-hero-fullwidth") }
  it { is_expected.to have_css("picture") }
  it { is_expected.to have_css("img[src='#{image_path}']") }

  context "when the image is not provided" do
    let(:image_path) { nil }

    it "does not render the picture element" do
      expect(page).not_to have_css("picture")
    end
  end
end
