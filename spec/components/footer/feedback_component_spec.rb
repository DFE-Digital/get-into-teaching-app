require "rails_helper"

describe Footer::FeedbackComponent, type: "component" do
  subject! { render_inline(described_class.new) }

  let(:feedback_selector) { ".feedback-bar" }

  specify "renders the talk to us component" do
    expect(page).to have_css(feedback_selector)
  end

  specify "the content is present" do
    href = "https://docs.google.com/forms/d/188D1TqsGr-OdcMHC76HMoYnHqcES4LVfl1CT1C_59QU/viewform"
    expect(page).to have_link("Tell us what you think about our website", href: href)
  end
end
