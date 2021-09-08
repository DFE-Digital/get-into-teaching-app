require "rails_helper"

RSpec.describe CallsToAction::StoryComponent, type: :component do
  let(:name) { "Joey" }
  let(:link) { "/some-dir/some-page" }
  let(:image_path) { "media/images/content/hero-images/0012.jpg" }
  let(:heading) { "Lorem ipsum sit dolorem" }
  let(:text) { "Venenatismorbi anunc diamsuspendisse pretiumin sollicitudindonec." }

  let(:args) { { name: name, heading: heading, image: image_path, link: link, text: text } }

  let(:component) { described_class.new(args) }

  before { render_inline(component) }

  specify "renders the call to action" do
    expect(page).to have_css(".call-to-action")
  end

  specify "the call to action contains the image" do
    image_element = page.find("img")
    expect(image_element[:src]).to match(%r{media/images.*\.jpg})
  end

  specify "the link is present" do
    page.find(".call-to-action__action") do |cta|
      expect(cta).to have_link(%(Read #{name}'s story), href: link)
    end
  end

  specify "the heading and text are present" do
    expect(page).to have_css(".call-to-action__contents__heading", text: heading)
    expect(page).to have_css(".call-to-action__contents__story", text: text)
  end
end
