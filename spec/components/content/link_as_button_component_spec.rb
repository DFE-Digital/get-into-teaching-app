require "rails_helper"

RSpec.describe Content::LinkAsButtonComponent, type: :component do
  let(:link_text) { "Cookies" }
  let(:url) { "https://getintoteaching.education.gov.uk/cookies" }
  let(:options) { { class: "button--secondary" } }
  let(:component) do
    described_class.new(link_text: link_text, url: url, options: options)
  end

  context "when given additional attributes" do
    it "renders the link as a button with custom options and class/role of button" do
      render_inline(component)

      expect(page).to have_link(link_text, href: url)
      expect(page).to have_css("a.button.button--secondary[role='button']", text: link_text)
    end
  end

  context "when no additional attributes are given" do
    let(:options) { {} }

    it "renders the link as a button with default class/role of button" do
      render_inline(component)
      expect(page).to have_link(link_text, href: url)
      expect(page).to have_css("a.button[role='button']", text: link_text)
    end
  end

  context "when given an unallowed attribute" do
    let(:options) { { class: "button--secondary", panda: "bear" } }

    it "raises an ArgumentError" do
      # Expecting ArgumentError to be raised when the component is initialized with an invalid attribute
      expect {
        render_inline(component)
      }.to raise_error(ArgumentError, /Unexpected attributes: panda/)
    end
  end
end
