require "rails_helper"

RSpec.describe CallsToAction::ApplyComponent, type: :component do
  let(:icon) { "icon-question" }
  let(:title) { "Joey" }
  let(:text) { "Venenatismorbi anunc diamsuspendisse pretiumin sollicitudindonec." }
  let(:link_text) { "Click here" }
  let(:link_target) { "/some-dir/some-page" }
  let(:content) { "some content" }

  describe "rendering the component" do
    let(:kwargs) { { icon: icon, title: title, text: text, link_text: link_text, link_target: link_target } }

    let(:component) { described_class.new(**kwargs) }

    before { render_inline(component) { content } }

    specify "renders the call to action" do
      expect(page).to have_css(".call-to-action")
    end

    specify "the icon is present" do
      image_element = page.find("img")

      expect(image_element[:src]).to match(Regexp.new(icon))
      expect(image_element[:alt]).to eql("")
    end

    specify "the title is present" do
      expect(page).to have_css(".call-to-action__heading", text: title)
    end

    specify "the text is present" do
      expect(page).to have_css("p", text: text)
    end

    specify "the content is present" do
      expect(page).to have_css("p", text: content)
    end

    specify "the link is present" do
      expect(page).to have_link(link_text, href: link_target)
    end

    context "when no title is present" do
      let(:kwargs) { { icon: icon, text: text, link_text: link_text, link_target: link_target } }

      specify "no paragraph tag should be rendered" do
        expect(page).not_to have_css("h4", class: "call-to-action__heading")
      end
    end

    context "when no link is present" do
      let(:link_text) { nil }
      let(:link_target) { nil }

      it { expect(page).not_to have_css("a") }
    end

    context "when no text or content are present" do
      let(:text) { nil }
      let(:content) { nil }

      specify "no paragraph tag should be rendered" do
        expect(page).not_to have_css("p", class: "call-to-action__text")
      end
    end

    context "when the heading_tag is overridden" do
      let(:custom_heading_tag) { "h4" }
      let(:component) { described_class.new(
        icon: icon, title: title, text: text, link_text: link_text, link_target: link_target, heading_tag: custom_heading_tag
      )}

      specify "the custom heading tag is used" do
        expect(page).to have_css("#{custom_heading_tag}.call-to-action__heading", text: title)
      end
    end
  end
end
