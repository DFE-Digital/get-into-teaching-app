require "rails_helper"

RSpec.describe CallsToAction::MultipleButtonsComponent, type: :component do
  let(:icon) { "icon-question" }
  let(:title) { "Many buttons" }

  let(:links) do
    { "first button" => "/first/link", "second button" => "/second/link" }
  end

  let(:component) { CallsToAction::MultipleButtonsComponent.new(icon: icon, title: title, links: links) }

  before { render_inline(component) }

  specify "renders the call to action" do
    expect(page).to have_css(".call-to-action.call-to-action--multiple-buttons")
  end

  specify "the title is present" do
    expect(page).to have_css("h4", text: title)
  end

  specify "all the links are present" do
    links.each do |text, href|
      expect(page).to have_link(text, href: href)
    end
  end
end
