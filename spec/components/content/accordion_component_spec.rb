require "rails_helper"

describe Content::AccordionComponent, type: "component" do
  describe "Rending the accordion" do
    let(:steps) do
      {
        "Step one" => "some content",
        "Step two" => "some other content",
        "Step three" => "even more content",
      }.with_indifferent_access
    end

    subject! do
      render_inline(Content::AccordionComponent.new) do |accordion|
        steps.each do |title, content|
          accordion.slot(:step, title: title) { content }
        end
      end
    end

    specify "renders an accordion container" do
      expect(page).to have_css(".accordions")
    end

    specify "the accordion has the right number of steps" do
      1.upto(steps.size) { |i| expect(page).to have_css(%(section#step-#{i}.step)) }
    end

    specify "each step has a button with the appropriate data attributes" do
      expect(page).to have_css(
        %(section.step > button.step-header[data-action="click->accordion#toggle"][data-target="accordion.header"]),
        count: steps.size,
      )
    end

    specify "each step has a section with the appropriate content and data attributes" do
      steps.each_value do |content|
        expect(page).to have_css(
          %(section.step > .step-content.collapsable[data-target="accordion.content"]),
          text: content,
        )
      end
    end

    context "when there are no steps" do
      let(:steps) { {} }
      specify "nothing is rendered" do
        expect(page).not_to have_css(".accordions")
      end
    end
  end

  describe "Calls to action" do
    let(:title) { "some title" }
    let(:text) { "some text" }

    describe "chat_online" do
      subject do
        render_inline(Content::AccordionComponent.new) do |accordion|
          accordion.slot(:step, title: title, call_to_action: call_to_action) do
            text
          end
        end
      end

      describe "when a call to action is specified" do
        let(:call_to_action) { "chat_online" }
        before { subject }

        specify "the title and content are rendered" do
          expect(page).to have_content(title)
          expect(page).to have_content(text)
        end

        specify "the call to action should be rendered" do
          expect(page).to have_css(".call-to-action--chat-online")
        end
      end

      describe "when an invalid call to action is specified" do
        let(:call_to_action) { "send_a_telegram" }

        specify "an error is raised" do
          expect { subject }.to raise_error(ArgumentError, /action not registered: #{call_to_action}/)
        end
      end
    end

    describe "story" do
      subject do
        render_inline(Content::AccordionComponent.new) do |accordion|
          accordion.slot(:step, title: title, call_to_action: call_to_action)
        end
      end

      describe "when a call to action is specified" do
        let(:name) { "Story name" }
        let(:heading) { "Story heading" }
        let(:call_to_action) do
          {
            "name" => "story",
            "arguments" => {
              "name" => name,
              "heading" => heading,
              "image" => "/an-image.jpg",
              "link" => "/some-link",
              "text" => "The quick brown fox",
            },
          }
        end

        before { subject }

        specify "the story component is rendered" do
          expect(page).to have_css(".call-to-action--story")
          expect(page).to have_content(heading)
          expect(page).to have_content(name)
        end
      end
    end
  end
end
