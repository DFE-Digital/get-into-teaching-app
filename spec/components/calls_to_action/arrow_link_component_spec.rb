require "rails_helper"

RSpec.describe CallsToAction::ArrowLinkComponent, type: :component do
  let(:link_text) { "Click here" }
  let(:link_target) { "/some-dir/some-page" }

  describe "rendering the component" do
    let(:kwargs) { { link_text: link_text, link_target: link_target } }

    let(:component) { described_class.new(**kwargs) }

    before { render_inline(component) { content } }

    specify "renders the green arrow icon" do
      expect(page).to have_css(".cta-circle-button")
      expect(page).to have_css("i.fa-arrow-right")
    end

    specify "the link text is present" do
      expect(page).to have_css(".cta-link-text", text: link_text)
    end

    specify "the link is present" do
      expect(page).to have_link(link_text, href: link_target)
    end
  end
end
