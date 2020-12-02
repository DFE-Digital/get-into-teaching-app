require "rails_helper"

RSpec.describe Content::Accordion::StoryComponent, type: :component do
  let(:name) { "Joey" }
  let(:link) { "/some-dir/some-page" }
  let(:image_path) { "media/images/hero-home-dt.jpg" }
  let(:heading) { "Lorem ipsum sit dolorem" }
  let(:text) { "Venenatismorbi anunc diamsuspendisse pretiumin sollicitudindonec." }

  let(:args) { { name: name, heading: heading, image: image_path, link: link, text: text } }

  let(:component) { Content::Accordion::StoryComponent.new(args) }
  before { render_inline(component) }

  specify "renders the call to action" do
    expect(page).to have_css(".call-to-action")
  end

  specify "the call to action contains the image" do
    image_element = page.find("img")
    expect(image_element[:src]).to match(image_path)
  end

  specify "the link is present" do
    expect(page).to have_link(%(Read #{name}'s story), href: link, class: "call-to-action__contents__button")
  end

  specify "the heading and text are present" do
    expect(page).to have_css("h3", text: heading)
    expect(page).to have_css("p", text: text)
  end
end
