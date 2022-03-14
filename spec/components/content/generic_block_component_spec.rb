require "rails_helper"

describe Content::GenericBlockComponent, type: "component" do
  subject! do
    render_inline(described_class.new(title: title, icon_image: icon_image, icon_size: icon_size, classes: Array.wrap(custom_class))) do
      content
    end
    page
  end

  let(:title) { "Block of content" }
  let(:content) { "Some content" }
  let(:icon_image) { "icon-school-black.svg" }
  let(:custom_class) { "purple" }
  let(:icon_size) { "30x50" }

  it { is_expected.to have_css("div.#{custom_class}") }
  it { is_expected.to have_css("h3", text: title) }
  it { is_expected.to have_content(content) }
  it { is_expected.to have_css(%(img[width="30"])) }
  it { is_expected.to have_css(%(img[height="50"])) }

  context "when icon_size is nil" do
    let(:icon_size) { nil }

    it { is_expected.not_to have_css(%(img[width])) }
    it { is_expected.not_to have_css(%(img[height])) }
  end
end
