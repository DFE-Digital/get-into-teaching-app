require "rails_helper"

describe Footer::FeedbackComponent, type: "component" do
  subject! { render_inline(described_class.new) }

  let(:feedback_selector) { ".feedback-bar" }

  specify "renders the talk to us component" do
    expect(page).to have_css(feedback_selector)
  end

  specify "the content is present" do
    expect(page).to have_content(/Is this page helpful\?/)
    expect(page).to have_link("Tell us what you think")
  end

  specify "Has valid GTM targets" do
    expect(page).to have_css(".page-question__answer", text: "Yes")
    expect(page).to have_css(".page-question__answer", text: "No")
  end
end
