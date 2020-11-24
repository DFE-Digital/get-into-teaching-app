require "rails_helper"

describe Content::AccordionComponent, type: "component" do
  let(:steps) do
    {
      "Step one"   => "some content",
      "Step two"   => "some other content",
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

  specify "renders an accordion" do
    expect(page).to have_css(".accordions")
  end

  specify "the accordion has the right number of steps" do
    1.upto(steps.size) { |i| expect(page).to have_css(%(section#step-#{i}.step)) }
  end

  specify "each step has a button with the appropriate data attributes" do
    expect(page).to have_css(
      %(section.step > button.step-header[data-action="click->accordion#toggle"][data-target="accordion.header"]),
      count: steps.size
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
