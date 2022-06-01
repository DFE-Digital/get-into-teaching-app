require "rails_helper"

describe Footer::CookieAcceptanceComponent, type: "component" do
  subject { render_inline(described_class.new) }

  let(:cookie_acceptance_selector) { ".cookie-acceptance" }

  specify "all anchor links are excluded from tab sequence" do
    subject
    expect(page.all("a").map { |e| e[:tabindex] }).to all(eq("-1"))
  end

  specify "renders the cookie acceptance component" do
    subject
    expect(page).to have_css(cookie_acceptance_selector)
  end

  specify "the content is present" do
    subject
    expect(page).to have_content(/We use cookies to collect/)
  end

  context "when the user agent is Silktide" do
    before do
      allow_any_instance_of(ActionDispatch::TestRequest).to(
        receive(:user_agent).and_return("a-user-agent-string-that-ends-in-Silktide"),
      )
      subject
    end

    specify "nothing is rendered" do
      expect(@rendered_content).to be_empty
    end
  end
end
