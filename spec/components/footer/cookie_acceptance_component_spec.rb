require "rails_helper"

describe Footer::CookieAcceptanceComponent, type: "component" do
  subject! { render_inline(described_class.new) }
  let(:cookie_acceptance_selector) { ".cookie-acceptance" }

  specify "renders the cookie acceptance component" do
    expect(page).to have_css(cookie_acceptance_selector)
  end

  specify "the content is present" do
    expect(page).to have_content(/We use cookies to collect/)
  end
end
