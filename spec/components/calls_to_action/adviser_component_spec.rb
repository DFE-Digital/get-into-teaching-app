require "rails_helper"

RSpec.describe CallsToAction::AdviserComponent, type: :component do
  let(:title) { "Some Title" }
  let(:text) { "Lorum ipsum dollar" }
  let(:image) { "static/images/adviser-black.png" }
  let(:link_text) { "Find out more about advisers" }
  let(:link_target) { "/somewhere" }

  describe "rendering the component" do
    let(:kwargs) { { title: title, text: text, image: image, link_text: link_text, link_target: link_target } }
    let(:component) { described_class.new(**kwargs) }

    before { render_inline(component) { content } }

    specify "renders the adviser component" do
      expect(page).to have_css(".adviser")
    end

    specify "the image is present" do
      image_element = page.find("img")

      expect(image_element[:src]).to match(Regexp.new(File.basename(image, ".*")))
      expect(image_element[:alt]).to eql("")
    end

    specify "the title is present" do
      expect(page).to have_css(".heading-l", text: title)
    end

    specify "the text is present" do
      expect(page).to have_css("p.adviser__text", text: text)
    end

    specify "the link is present" do
      expect(page).to have_link(link_text, href: link_target)
    end

    context "when no title is present" do
      let(:kwargs) { { text: text, image: image, link_text: link_text, link_target: link_target } }

      specify "it should use the default title" do
        expect(page).to have_css(".heading-l", text: "Get free one-to-one support")
      end
    end

    context "when no link is present" do
      let(:link_text) { nil }
      let(:link_target) { nil }

      it { expect(page).not_to have_css("a") }
    end

    context "when no text is present" do
      let(:text) { nil }

      specify "no paragraph tag should be rendered" do
        expect(page).not_to have_css("p.adviser__text")
      end
    end

    context "when the heading_tag is overridden" do
      let(:custom_heading_tag) { "h4" }
      let(:component) do
        described_class.new(
          title: title, text: text, image: image, link_text: link_text, link_target: link_target, heading_tag: custom_heading_tag,
        )
      end

      specify "the custom heading tag is used" do
        expect(page).to have_css("#{custom_heading_tag}.heading-l", text: title)
      end
    end
  end
end
