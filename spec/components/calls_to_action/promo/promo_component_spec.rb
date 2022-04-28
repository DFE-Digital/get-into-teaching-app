require "rails_helper"

RSpec.describe CallsToAction::Promo::PromoComponent, type: :component do
  let(:component) { described_class.new }

  before do
    render_inline(component) do |c|
      c.left_section(
        caption: "left-caption",
        heading: "left-heading",
        link_text: "left-link-text",
        link_target: "/left-link-target",
      ) { "left-content" }

      c.right_section(
        caption: "right-caption",
        heading: "right-heading",
      ) { "right-content" }
    end
  end

  subject { page }

  it { is_expected.to have_css(".promo") }

  describe "left side" do
    it { is_expected.to have_css(".promo__left h2", text: "left-heading") }
    it { is_expected.to have_css(".promo__left h2 > .caption", text: "left-caption") }
    it { is_expected.to have_css(".promo__left .promo__content", text: "left-content") }
    it { is_expected.to have_link("left-link-text", href: "/left-link-target") }
  end

  describe "right side" do
    it { is_expected.to have_css(".promo__right h2", text: "right-heading") }
    it { is_expected.to have_css(".promo__right h2 > .caption", text: "right-caption") }
    it { is_expected.to have_css(".promo__right", text: "right-content") }
  end
end
