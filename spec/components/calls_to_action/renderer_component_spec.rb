require "rails_helper"

RSpec.describe CallsToAction::RendererComponent, type: :component do
  {
    "simple component" => {
      "name" => "simple",
      "arguments" => {
        "title" => "simple component",
        "link_target" => "#simple-component",
        "link_text" => "simple component link",
        "icon" => "icon-person",
      },
    },
    "chat online component" => "chat_online",
    "next steps component" => "next_steps",
    "story component" => {
      "name" => "story",
      "arguments" => {
        "name" => "story component",
        "link" => "/story/component",
        "text" => "this is a story component",
        "heading" => "story component heading",
        "image" => "chat-online-card.jpg",
      },
    },
  }.each do |name, meta|
    describe "rendering a #{name}" do
      let(:component) { described_class.new(meta) }
      before { render_inline(component) }

      specify "renders the #{name} component correctly" do
        expect(page).to have_css(".call-to-action")
      end
    end
  end
end
