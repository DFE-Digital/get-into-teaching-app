require "rails_helper"

describe Content::ExpanderComponent, type: :component do
  subject do
    render_inline(component)
    page
  end

  let(:component) do
    described_class.new(
      header: header,
      title: title,
      text: text,
      link_title: link_title,
      link_url: link_url,
      background: background,
      expanded: expanded,
      classes: classes,
    )
  end
  let(:header) { "header goes here" }
  let(:title) { "title goes here" }
  let(:text) { "text goes here" }
  let(:link_title) { "link title goes here" }
  let(:link_url) { "/somewhere/over/the/rainbow" }
  let(:background) { "gitpink" }
  let(:expanded) { false }
  let(:classes) { "extra-class1 extra-class2" }

  describe "expander classes" do
    it { is_expected.to have_css(".expander-details") }
    it { is_expected.to have_css(".expander-details__background-gitpink") }
    it { is_expected.to have_css(".extra-class1") }
    it { is_expected.to have_css(".extra-class2") }
  end

  describe "expander header" do
    it { is_expected.to have_css("span.expander-details__summary__header", text: header) }
  end

  describe "expander title" do
    it { is_expected.to have_css("span.expander-details__summary__title", text: title) }
  end

  describe "show_link_id" do
    it { is_expected.to have_css("#show-header-goes-here-title-goes-here") }
  end

  describe "hide_link_id" do
    it { is_expected.to have_css("#hide-header-goes-here-title-goes-here") }
  end

  describe "details_id" do
    it { is_expected.to have_css("#details-header-goes-here-title-goes-here") }
  end

  context "when the expander is closed" do
    it { is_expected.not_to have_link(link_title, href: link_url) }
    it { is_expected.not_to have_css("div.expander-details__text p", text: text) }
  end

  context "when the expander is opened" do
    let(:expanded) { true }

    it { is_expected.to have_link(link_title, href: link_url) }
    it { is_expected.to have_css("div.expander-details__text p", text: text) }
  end

  context "when both text and a content block are given" do
    let(:expanded) { true }

    subject do
      render_inline(component) { "content block goes here" }
      page
    end

    it "renders the content block" do
      is_expected.to have_css("div.expander-details__text div", text: "content block goes here")
    end

    it "does not render the text" do
      is_expected.not_to have_css("div.expander-details__text p", text: text)
    end
  end

  describe "link title" do
    let(:link_title) { " link title with a full stop. " }
    let(:expanded) { true }

    it { is_expected.to have_link("link title with a full stop", href: link_url) }
    it { is_expected.not_to have_link("link title with a full stop.", href: link_url) }
  end

  describe "argument checks" do
    it do
      expect { described_class.new(text: text, title: nil) }.to \
        raise_error(ArgumentError, "title must be present")
    end

    it do
      expect { described_class.new(text: text, title: "  ") }.to \
        raise_error(ArgumentError, "title must be present")
    end

    it do
      expect { described_class.new(text: text, title: title, background: "green") }.to \
        raise_error(ArgumentError, "background must be a valid value")
    end
  end

  describe "text or content checks" do
    it "raises when both text and content are blank" do
      expect { render_inline(described_class.new(title: title, text: nil)) }.to \
        raise_error(ArgumentError, "text or content must be present")
    end

    it "raises when text is blank and no content block is given" do
      expect { render_inline(described_class.new(title: title, text: "  ")) }.to \
        raise_error(ArgumentError, "text or content must be present")
    end

    it "does not raise when text is blank but content is present" do
      expect { render_inline(described_class.new(title: title, text: "  ")) { "some content" } }.not_to \
        raise_error
    end
  end
end
