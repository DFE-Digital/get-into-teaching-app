require "rails_helper"

describe Content::MailingListComponent, type: :component do
  subject(:render) do
    render_inline(component)
    page
  end

  let(:color) { "pink" }
  let(:margin) { true }
  let(:heading) { :m }
  let(:component) { described_class.new(title: "title", intro: "intro", color: color, heading: heading, margin: margin) }

  it { is_expected.to have_css("h2.heading-m.heading--box-#{color}", text: "title") }
  it { is_expected.to have_css("p", text: "intro") }
  it { is_expected.to have_css(".action-container--#{color}") }
  it { is_expected.to have_css("form") }
  it { is_expected.to have_link("privacy notice", href: "/privacy-policy?id=123") }
  it { is_expected.not_to have_css(".action-container--no-margin") }

  context "when color is trasparent" do
    let(:color) { "transparent" }

    it { is_expected.to have_css(".action-container--transparent") }
    it { is_expected.not_to have_css("h2.heading--box-transparent") }
  end

  context "with a different heading" do
    let(:heading) { :l }

    it { is_expected.to have_css("h2.heading-l", text: "title") }
  end

  context "with no margin" do
    let(:margin) { false }

    it { is_expected.to have_css(".action-container--no-margin") }
  end
end
