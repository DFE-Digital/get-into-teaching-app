require "rails_helper"

RSpec.describe SubjectSpecific::TextBlockWithOneImageComponent, type: "component" do
  subject! { Capybara.string(component) }

  let(:heading) { "A heading" }
  let(:image_path) { "media/images/content/hero-images/0013.jpg" }
  let(:image_alt) { "A very nice photograph" }
  let(:colour) { nil }
  let(:component) { render_inline(described_class.new(heading: heading, image_path: image_path, image_alt: image_alt, colour: colour)) }

  it { is_expected.to have_css("section.text-block-with-one-image") }
  it { is_expected.to have_css(".statement > h2.xlarge", text: heading) }
  it { is_expected.to have_css(%(img[alt='#{image_alt}'])) }

  context "when the colour is overriden" do
    let(:colour) { "pink" }

    it { is_expected.to have_css(".statement > h2.xlarge.pink", text: heading) }
  end
end
