require "rails_helper"

describe Content::HeadingComponent, type: :component do
  let(:heading) { "Heading" }
  let(:tag) { :h2 }
  let(:heading_size) { :xl }
  let(:caption) { nil }
  let(:caption_size) { :m }
  let(:caption_bold) { false }
  let(:caption_purple) { false }

  let(:component) do
    described_class.new(
      heading: heading,
      tag: tag,
      heading_size: heading_size,
      caption: caption,
      caption_size: caption_size,
      caption_bold: caption_bold,
      caption_purple: caption_purple,
      class: %w[custom-class],
    )
  end

  subject(:render) do
    render_inline(component)
    page
  end

  it { is_expected.to have_css("h2.heading-xl.custom-class span", text: heading) }

  it { is_expected.not_to have_css(".heading--with-caption") }

  context "when heading is blank" do
    let(:heading) { "" }

    it { is_expected.not_to have_css("h2") }
  end

  context "when given a caption" do
    let(:caption) { "Caption" }

    it { is_expected.to have_css("h2.heading--with-caption") }
    it { is_expected.to have_css("span.caption-m", text: caption) }

    it { is_expected.not_to have_css("span.caption--purple") }
    it { is_expected.not_to have_css("span.caption--bold") }

    context "when caption_purple is true" do
      let(:caption_purple) { true }

      it { is_expected.to have_css("span.caption--purple") }
    end

    context "when caption_bold is true" do
      let(:caption_bold) { true }

      it { is_expected.to have_css("span.caption--bold") }
    end
  end

  describe "validation" do
    context "when the heading_size is invaid" do
      let(:heading_size) { :massive }

      it { expect { render }.to raise_error(ArgumentError, "heading_size must be :s, :m, :l, :xl or :xxl") }
    end

    context "when the tag is invaid" do
      let(:tag) { :div }

      it { expect { render }.to raise_error(ArgumentError, "tag must be :h1, :h2, :h3 or :h4") }
    end

    context "when the caption_size is invaid" do
      let(:caption_size) { :tiny }

      it { expect { render }.to raise_error(ArgumentError, "caption_size must be :m, :l or :xxl") }
    end
  end
end
