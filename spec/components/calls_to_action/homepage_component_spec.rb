require "rails_helper"

RSpec.describe CallsToAction::HomepageComponent, type: :component do
  let(:icon) { "icon-question" }
  let(:image) { "static/images/dfelogo.png" }
  let(:title) { "Joey" }
  let(:link_text) { "Click here" }
  let(:link_target) { "/some-dir/some-page" }
  let(:caption) { "Caption text" }
  let(:badge_text) { "Badge text" }
  let(:text) { nil }

  describe "rendering the component" do
    let(:kwargs) do
      {
        icon: icon,
        title: title,
        link_text: link_text,
        link_target: link_target,
        image: image,
        text: text,
        caption: caption,
        badge_text: badge_text,
      }
    end

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

    specify "the caption is present" do
      expect(page).to have_css(".caption-m", text: caption)
    end

    specify "the link is present" do
      expect(page).to have_link(link_text, href: link_target)
    end

    specify "the image is present" do
      expect(page.find(".call-to-action__image")["style"]).to include("packs-test/v1/static/images/dfelogo")
    end

    specify "the badge_text is present" do
      expect(page).to have_css(".call-to-action__image .badge", text: badge_text)
    end

    context "when text is present" do
      let(:text) { "some text" }

      it "renders the text" do
        expect(page).to have_css(".call-to-action__content p", text: text)
      end
    end

    context "when caption is not present" do
      let(:caption) { nil }

      it { expect(page).not_to have_css(".caption-m") }
    end

    context "when badge_text is not present" do
      let(:badge_text) { nil }

      it { expect(page).not_to have_css(".badge") }
    end
  end
end
