require "rails_helper"

describe FooterComponent, type: "component" do
  subject(:render) { render_inline(described_class.new) }

  before { render }

  specify "renders the footer" do
    expect(page).to have_css(".site-footer")
  end

  specify "renders the 'Talk To Us' section" do
    expect(page).to have_css(".talk-to-us")
  end

  specify "renders the cookie acceptance popup" do
    expect(page).to have_css(".cookie-acceptance")
  end

  context "when 'Talk to us' is disabled" do
    subject! { render_inline(described_class.new(talk_to_us: false)) }

    specify "does not render the 'Talk to us' section" do
      expect(page).not_to have_css(talk_to_us_selector)
    end
  end
end
