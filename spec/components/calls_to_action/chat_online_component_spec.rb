require "rails_helper"

RSpec.describe CallsToAction::ChatOnlineComponent, type: :component do
  let(:component) { CallsToAction::ChatOnlineComponent.new }
  before { render_inline(component) }

  specify "renders a call to action" do
    expect(page).to have_css(".call-to-action")
  end

  specify "the call to action invokes the talk-to-us Stimulus controller" do
    expect(page).to have_css(%(.call-to-action[data-controller="talk-to-us"]))
  end

  specify "some useful text is included" do
    expect(page).to have_css(".call-to-action__text", text: /chat to us/)
  end

  specify %(the "Chat online" button will start a chat) do
    expect(page).to have_css(
      %(.call-to-action__action > button[data-action="click->talk-to-us#startChat"]),
      text: "Chat online",
    )
  end
end
