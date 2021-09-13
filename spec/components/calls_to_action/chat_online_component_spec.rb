require "rails_helper"

RSpec.describe CallsToAction::ChatOnlineComponent, type: :component do
  let(:component) { described_class.new }

  before { render_inline(component) }

  specify "renders a call to action" do
    expect(page).to have_css(".call-to-action")
  end

  specify "the call to action invokes the talk-to-us Stimulus controller" do
    expect(page).to have_css(%(.call-to-action [data-controller="talk-to-us"]))
  end

  specify "some useful text is included" do
    expect(page).to have_css(".call-to-action__text", text: /chat to us/)
  end

  specify %(the "Chat online" button will start a chat) do
    expect(page).to have_css(
      %(.call-to-action__action > a[data-action="talk-to-us#startChat"]),
      text: "Chat online",
    )
  end

  context "when a custom title is passed in" do
    let(:title_text) { "Converse" }
    let(:component) { described_class.new(title: title_text) }

    specify "some useful text is included" do
      expect(page).to have_css(".call-to-action .call-to-action__heading", text: title_text)
    end
  end

  context "when custom text is passed in" do
    let(:content) { "Some helpful text should go here" }
    let(:component) { described_class.new(text: content) }

    specify "some useful text is included" do
      expect(page).to have_css(".call-to-action .call-to-action__text", text: content)
    end
  end

  context "when custom button text is passed in" do
    let(:button_text) { "Gossip instantly" }
    let(:component) { described_class.new(button_text: button_text) }

    specify "some useful text is included" do
      expect(page).to have_css(".call-to-action .call-to-action__action", text: button_text)
    end
  end
end
