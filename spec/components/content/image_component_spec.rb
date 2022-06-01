require "rails_helper"

describe Content::ImageComponent, type: "component" do
  let(:image_name) { "content/hero-images/0024" }
  let(:example_args) { { path: "media/images/#{image_name}.jpg" } }

  before { render_inline(described_class.new(**example_args)) }

  specify "image has the right path" do
    expect(@rendered_content).to match(%r{src="/packs-test/v1/media/images/#{image_name}-.*.jpg"})
  end

  specify "image has the right alt text" do
    alt = Image.new.alt(example_args[:path])

    expect(page).to have_css(%(img[alt='#{alt}']))
  end
end
