require "rails_helper"

RSpec.describe CallsToAction::SimpleComponent, type: :component do
  let(:icon) { "icon-question" }
  let(:title) { "Joey" }
  let(:text) { "Venenatismorbi anunc diamsuspendisse pretiumin sollicitudindonec." }
  let(:link_text) { "Click here" }
  let(:link_target) { "/some-dir/some-page" }

  let(:kwargs) { { icon: icon, title: title, text: text, link_text: link_text, link_target: link_target } }

  let(:component) { CallsToAction::SimpleComponent.new(kwargs) }
  before { render_inline(component) }

  specify "renders the call to action" do
    expect(page).to have_css(".call-to-action")
  end

  specify "the icon is present" do
    image_element = page.find("img")
    expect(image_element[:src]).to match(Regexp.new(icon))
  end

  specify "the title is present" do
    expect(page).to have_css("h4", text: title)
  end

  specify "the text is present" do
    expect(page).to have_css("p", text: text)
  end

  specify "the link is present" do
    expect(page).to have_link(link_text, href: link_target)
  end
end
