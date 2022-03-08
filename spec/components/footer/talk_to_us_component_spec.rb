require "rails_helper"

describe Footer::TalkToUsComponent, type: "component" do
  subject! { render_inline(described_class.new) }

  let(:talk_to_us_selector) { ".talk-to-us" }

  specify "renders the talk to us component" do
    expect(page).to have_css(talk_to_us_selector)
  end

  specify "the content is present" do
    expect(page).to have_content(/Teacher training advisers provide free/)
    expect(page).to have_content(/Call us/)
    expect(page).to have_content(/Chat online/)
  end
end
