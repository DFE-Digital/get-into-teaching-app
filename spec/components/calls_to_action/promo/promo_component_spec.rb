require "rails_helper"

RSpec.describe CallsToAction::Promo::PromoComponent, type: :component do
  let(:component) { described_class.new }

  let(:left_args) do
    {
      caption: "left-caption",
      heading: "left-heading",
      link_text: "left-link-text",
      link_target: "/left-link-target",
    }
  end

  let(:right_args) do
    {
      caption: "right-caption",
      heading: "right-heading",
    }
  end

  before do
    render_inline(component) do |c|
      c.left_section(**left_args) { "left-content" }
      c.right_section(**right_args) { "right-content" }
    end
  end

  subject { page }

  it { is_expected.to have_css(".promo") }

  describe "left side" do
    it { is_expected.to have_css(".promo__left h2", text: "left-heading") }
    it { is_expected.to have_css(".promo__left h2 > .caption", text: "left-caption") }
    it { is_expected.to have_css(".promo__left .promo__content", text: "left-content") }
    it { is_expected.to have_link("left-link-text", href: "/left-link-target") }

    context "when the caption is omitted" do
      let(:left_args) { { heading: "left-heading-no-link" } }

      it { is_expected.not_to have_css(".promo__left .caption") }
    end

    context "when the link is omitted" do
      let(:left_args) { { caption: "left-caption-no-link", heading: "left-heading-no-link" } }

      it { is_expected.not_to have_css(".promo__left a") }
    end

    context "when classes are provided" do
      let(:left_args) { { heading: "heading", classes: %w[one two three] } }

      it {
        is_expected.to have_css(".promo__left.one.two.three")
      }
    end
  end

  describe "right side" do
    it { is_expected.to have_css(".promo__right h2", text: "right-heading") }
    it { is_expected.to have_css(".promo__right h2 > .caption", text: "right-caption") }
    it { is_expected.to have_css(".promo__right", text: "right-content") }

    context "when the caption is omitted" do
      let(:right_args) { { heading: "right-heading-no-link" } }

      it { is_expected.not_to have_css(".promo__right .caption") }
    end
  end
end
