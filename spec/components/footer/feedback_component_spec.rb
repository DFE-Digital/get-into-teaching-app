require "rails_helper"

describe Footer::FeedbackComponent, type: "component" do
  subject! { render_inline(described_class.new) }

  let(:feedback_selector) { ".feedback-bar" }

  specify "renders the talk to us component" do
    expect(page).to have_css(feedback_selector)
  end

  specify "the content is present" do
    href = "https://docs.google.com/forms/d/e/1FAIpQLSdBXbU5nwP6_3TH7HY5rB4ehkSDNzfKqB5X2G7wG4K6LY97-g/viewform"
    expect(page).to have_link("Tell us what you think about this service", href: href)
  end
end
