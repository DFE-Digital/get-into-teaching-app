require "rails_helper"

describe Content::GenericBlockComponent, type: "component" do
  let(:title) { "Block of content" }
  let(:content) { "Some content" }
  let(:icon_image) { "icon-school-black.svg" }
  let(:icon_alt) { "description of image" }
  let(:custom_class) { "purple" }

  subject! do
    render_inline(described_class.new(title: title, icon_image: icon_image, icon_alt: icon_alt, classes: Array.wrap(custom_class))) do
      content
    end
    page
  end

  it { is_expected.to have_css("div.#{custom_class}") }
  it { is_expected.to have_css("h3", text: title) }
  it { is_expected.to have_content(content) }
  it { is_expected.to have_css(%(img[alt="#{icon_alt}"])) }
end
