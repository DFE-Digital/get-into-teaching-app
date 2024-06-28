require "rails_helper"

describe HeaderComponent, type: "component" do
  before do
    allow(ENV).to receive(:[]).and_call_original
    allow(ENV).to receive(:[]).with("GTM_ID").and_return("abc123")
  end

  subject! { render_inline(described_class.new) }

  let(:front_matter) do
    { title: "What a nice page" }
  end

  specify "renders the GTM fallback script" do
    expect(page).to have_css("noscript#gtm-fallback")
  end

  specify "renders a skiplink container" do
    expect(page).to have_css("#skiplink-container")
  end

  specify "renders the navigation" do
    expect(page).to have_css("nav > ol.primary")
  end

  specify "doesn't render breadcrumbs by default" do
    expect(page).not_to have_css(".breadcrumb")
  end

  context "when breadcrumbs: true" do
    subject! { render_inline(described_class.new(breadcrumbs: true)) }

    specify "renders the breadcrumbs" do
      expect(page).to have_css(".breadcrumbs")
    end
  end
end
