require "rails_helper"

describe Content::InsetTextComponent, type: :component do
  let(:header) { "Header" }
  let(:text) { "Text" }
  let(:color) { "yellow" }
  let(:component) { described_class.new(text: text, header: header, color: color) }

  subject do
    render_inline(component)
    page
  end

  it { is_expected.to have_css("section.inset-text.yellow") }
  it { is_expected.to have_css(".inset-text p", text: text) }
  it { is_expected.to have_css(".inset-text h2 span.header", text: "#{header}:") }

  context "when there is a header" do
    let(:title) { nil }

    it { is_expected.to have_css(".inset-text h2 span.header", text: header) }
  end

  context "when the text contains HTML" do
    let(:text) { %(text with a <a href="#">link</a>) }

    it { is_expected.to have_css(".inset-text a", text: "link") }
  end

  context "when the text contains malicious HTML" do
    let(:text) { %{<script>alert();</script>} }

    it { is_expected.not_to have_css("script") }
  end

  context "when the color is grey" do
    let(:color) { "grey" }

    it { is_expected.to have_css("section.inset-text.grey") }
  end

  context "when the color is purple" do
    let(:color) { "purple" }

    it { is_expected.to have_css("section.inset-text.purple") }
  end

  context "when the heading_tag is overridden" do
    let(:custom_heading_tag) { "h4" }
    let(:component) { described_class.new(text: text, header: header, color: color, heading_tag: custom_heading_tag) }

    specify "the custom heading tag is used" do
      expect(subject).to have_css(".inset-text #{custom_heading_tag}[role=\"text\"]", text: header)
    end
  end
end
