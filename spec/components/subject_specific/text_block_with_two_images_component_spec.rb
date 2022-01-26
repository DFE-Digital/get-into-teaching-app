require "rails_helper"

RSpec.describe SubjectSpecific::TextBlockWithTwoImagesComponent, type: "component" do
  subject! { Capybara.string(component) }

  let(:heading) { "A heading" }
  let(:image_1_path) { "media/images/content/hero-images/0001.jpg" }
  let(:image_1_alt) { "Photo 1" }

  let(:image_2_path) { "media/images/content/hero-images/0002.jpg" }
  let(:image_2_alt) { "Photo 2" }
  let(:colour) { nil }

  let(:kwargs) do
    {
      heading: heading,
      image_1_path: image_1_path,
      image_1_alt: image_1_alt,
      image_2_path: image_2_path,
      image_2_alt: image_2_alt,
      colour: colour,
    }
  end

  let(:component) { render_inline(described_class.new(**kwargs)) }

  it { is_expected.to have_css("section.text-block-with-two-images") }
  it { is_expected.to have_css(".statement > h2.xlarge", text: heading) }
  it { is_expected.to have_css(%(img[alt='#{image_1_alt}'])) }
  it { is_expected.to have_css(%(img[alt='#{image_2_alt}'])) }

  context "when the colour is overriden" do
    let(:colour) { "pink" }

    it { is_expected.to have_css(".statement > h2.xlarge.pink", text: heading) }
  end
end
