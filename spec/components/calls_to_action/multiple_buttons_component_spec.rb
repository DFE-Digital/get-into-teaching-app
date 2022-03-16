require "rails_helper"

RSpec.describe CallsToAction::MultipleButtonsComponent, type: :component do
  let(:icon) { "icon-question" }
  let(:title) { "Many buttons" }

  let(:links) do
    { "first button" => "/first/link", "second button" => "/second/link" }
  end

  let(:component) { described_class.new(icon: icon, title: title, links: links) }

  before { render_inline(component) }

  specify "renders the icon and marks it as decorative" do
    image_element = page.find(".call-to-action__icon")

    expect(image_element[:src]).to match(Regexp.new(icon))
    expect(image_element[:alt]).to eql("")
  end

  specify "renders the call to action" do
    expect(page).to have_css(".call-to-action.call-to-action--multiple-buttons")
  end

  specify "the title is present" do
    expect(page).to have_css(".call-to-action__heading", text: title)
  end

  specify "all the links are present" do
    links.each do |text, href|
      expect(page).to have_link(text, href: href)
    end
  end
end
