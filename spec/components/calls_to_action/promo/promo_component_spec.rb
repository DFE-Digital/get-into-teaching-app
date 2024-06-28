require "rails_helper"

RSpec.describe CallsToAction::Promo::PromoComponent, type: :component do
  let(:border) { :top }
  let(:reverse) { false }
  let(:component) { described_class.new(border: border, reverse: reverse) }

  let(:left_args) { {} }
  let(:right_args) do
    {
      caption: "right-caption",
      heading: "right-heading",
    }
  end

  before do
    render_inline(component) do |c|
      c.with_left_section(**left_args)
      c.with_right_section(**right_args) { "right-content" }
    end
  end

  subject { page }

  it { is_expected.to have_css(".promo.promo--border-top") }
  it { is_expected.not_to have_css(".promo.promo--reverse") }

  context "when reversed" do
    let(:reverse) { true }

    it { is_expected.to have_css(".promo.promo--reverse") }
  end

  describe "left side" do
    context "when classes are provided" do
      let(:left_args) { { classes: %w[one two three] } }

      it {
        is_expected.to have_css(".promo__left.one.two.three")
      }
    end
  end

  describe "right side" do
    it { is_expected.to have_css(".promo__right h2", text: "right-heading") }
    it { is_expected.to have_css(".promo__right .caption-l", text: "right-caption") }
    it { is_expected.to have_css(".promo__right", text: "right-content") }

    context "when the caption is omitted" do
      let(:right_args) { { heading: "right-heading-no-link" } }

      it { is_expected.not_to have_css(".promo__right .caption") }
    end
  end
end
