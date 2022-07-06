require "rails_helper"

describe Content::InsetTextComponent, type: :component do
  let(:title) { "Title" }
  let(:text) { "Text" }
  let(:component) { described_class.new(text: text, title: title) }

  subject do
    render_inline(component)
    page
  end

  it { is_expected.to have_css("section.inset-text") }
  it { is_expected.to have_css(".inset-text p", text: text) }
  it { is_expected.to have_css(".inset-text h2", text: title) }

  context "when there is no title" do
    let(:title) { nil }

    it { is_expected.not_to have_css(".inset-text h2") }
  end

  context "when the text contains HTML" do
    let(:text) { %(text with a <a href="#">link</a>) }

    it { is_expected.to have_css(".inset-text a", text: "link") }
  end

  context "when the text contains malicious HTML" do
    let(:text) { %{<script>alert();</script>} }

    it { is_expected.not_to have_css("script") }
  end
end
