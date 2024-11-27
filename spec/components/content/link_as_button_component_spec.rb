require "rails_helper"

RSpec.describe Content::LinkAsButtonComponent, type: :component do
  let(:link_text) { "Cookies" }
  let(:href) { "https://getintoteaching.education.gov.uk/cookies" }
  let(:css_class) { ["button--secondary"] }
  let(:kwargs) { {} }
  let(:component) do
    described_class.new(link_text: link_text, href: href, css_class: css_class, **kwargs)
  end

  context "when given additional attributes" do
    it "renders the link as a button with custom options and class/role of button" do
      render_inline(component)

      expect(page).to have_link(link_text, href: href)
      expect(page).to have_css("a.button.button--secondary[role='button']", text: link_text)
    end
  end

  context "when no additional attributes are given" do
    let(:css_class) { [] }

    it "renders the link as a button with default class/role of button" do
      render_inline(component)
      expect(page).to have_link(link_text, href: href)
      expect(page).to have_css("a.button[role='button']", text: link_text)
    end
  end

  context "when given an unallowed attribute" do
    let(:kwargs) { { panda: "bear" } }

    it "does not render unallowed attributes" do
      expect {
        render_inline(component)
      }.to raise_error(ArgumentError, "Unhandled attributes: panda")
    end
  end
end
