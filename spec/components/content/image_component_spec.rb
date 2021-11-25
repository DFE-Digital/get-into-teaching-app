require "rails_helper"

describe Content::ImageComponent, type: "component" do
  let(:alt) { "Dark" }
  let(:image_name) { "dfelogo-black" }
  let(:example_args) { { path: "media/images/#{image_name}.svg", alt: alt } }

  before { render_inline(described_class.new(**example_args)) }

  specify "image has the right path" do
    expect(rendered_component).to match(%r{src="/packs-test/v1/media/images/#{image_name}-.*.svg"})
  end

  specify "image has the right alt text" do
    expect(page).to have_css(%(img[alt='#{alt}']))
  end
end
