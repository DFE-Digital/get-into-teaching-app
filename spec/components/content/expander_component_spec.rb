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
  let(:background) { "purple" }
  let(:expanded) { false }
  let(:classes) { "extra-class1 extra-class2" }

  describe "expander classes" do
    it { is_expected.to have_css(".expander-details") }
    it { is_expected.to have_css(".expander-details__background-purple") }
    it { is_expected.to have_css(".extra-class1") }
    it { is_expected.to have_css(".extra-class2") }
  end

  describe "expander header" do
    it { is_expected.to have_css("span.expander-details__summary__header", text: header) }
  end

  describe "expander title" do
    it { is_expected.to have_css("span.expander-details__summary__title", text: title) }
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

  describe "argument checks" do
    it do
      expect { described_class.new(title: title, text: nil) }.to \
        raise_error(ArgumentError, "text must be present")
    end

    it do
      expect { described_class.new(title: title, text: "  ") }.to \
        raise_error(ArgumentError, "text must be present")
    end

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
        raise_error(ArgumentError, "background must be purple")
    end
  end
end
