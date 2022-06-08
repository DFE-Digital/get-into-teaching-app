require "rails_helper"

RSpec.describe CallsToAction::ChatOnlineComponent, type: :component do
  let(:component) { described_class.new }

  before { render_inline(component) }

  specify "renders a call to action" do
    expect(page).to have_css(".call-to-action")
  end

  specify "the call to action invokes the chat Stimulus controller" do
    expect(page).to have_css(%(.call-to-action [data-controller=chat]))
  end

  specify "some useful text is included" do
    expect(page).to have_css(".call-to-action__text", text: /chat to us/)
  end

  specify %(the "Chat online" button will start a chat) do
    expect(page).to have_css(
      %(a[data-action="chat#start"]),
      text: "Chat online",
    )
  end

  context "when a custom title is passed in" do
    let(:title_text) { "Converse" }
    let(:component) { described_class.new(title: title_text) }

    specify "some useful text is included" do
      expect(page).to have_css(".call-to-action h2.call-to-action__heading", text: title_text)
    end

    context "when a custom heading_tag is specified" do
      let(:heading_tag) { "h4" }
      let(:component) { described_class.new(title: title_text, heading_tag: heading_tag) }

      specify "some useful text is included" do
        expect(page).to have_css(".call-to-action #{heading_tag}.call-to-action__heading", text: title_text)
      end
    end
  end

  context "when custom text is passed in" do
    let(:content) { "Some helpful text should go here" }
    let(:component) { described_class.new(text: content) }

    specify "some useful text is included" do
      expect(page).to have_css(".call-to-action .call-to-action__text", text: content)
    end
  end
end
