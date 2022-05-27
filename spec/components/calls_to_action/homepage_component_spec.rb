require "rails_helper"

RSpec.describe CallsToAction::HomepageComponent, type: :component do
  let(:icon) { "icon-question" }
  let(:image) { "media/images/dfelogo.png" }
  let(:title) { "Joey" }
  let(:link_text) { "Click here" }
  let(:link_target) { "/some-dir/some-page" }
  let(:text) { nil }

  describe "rendering the component" do
    let(:kwargs) { { icon: icon, title: title, link_text: link_text, link_target: link_target, image: image, text: text } }

    let(:component) { described_class.new(**kwargs) }

    before { render_inline(component) }

    specify "renders the call to action" do
      expect(page).to have_css(".call-to-action")
    end

    specify "the icon is present and is decorative" do
      image_element = page.find(".call-to-action__icon")
      expect(image_element[:src]).to match(Regexp.new(icon))
      expect(image_element[:alt]).to eql("")
    end

    specify "the title is present" do
      expect(page).to have_css(".call-to-action__heading", text: title)
    end

    specify "the link is present" do
      expect(page).to have_link(link_text, href: link_target)
    end

    specify "the image is present" do
      expect(page.find(".call-to-action__image")["style"]).to include("packs-test/v1/media/images/dfelogo")
    end

    context "when text is present" do
      let(:text) { "some text" }

      it "renders the text" do
        expect(page).to have_css(".call-to-action__content p", text: text)
      end
    end
  end
end
