require "rails_helper"

RSpec.describe CallsToAction::AdviserBlockComponent, type: :component do
  let(:title) { "Get a free adviser" }
  let(:image) { "adviser-block-promo.jpg" }
  let(:title_color) { "yellow" }
  let(:text) { "An adviser with years of teaching experience can help you become a teacher." }
  let(:link_text) { "Find out about advisers" }
  let(:link_target) { "/teacher-training-advisers" }

  let(:kwargs) do
    {
      title: title,
      image: image,
      title_color: title_color,
      text: text,
      link_text: link_text,
      link_target: link_target,
    }
  end

  before { render_inline(described_class.new(**kwargs)) }

  describe "rendering the adviser block component" do
    it "renders the outer div with class 'image-block'" do
      expect(page).to have_css("div.image-block")
    end

    it "renders the image with correct src and alt text" do
      image_element = page.find("img")
      expect(image_element[:src]).to match(Regexp.new("images/#{Regexp.escape(File.basename(image, '.*'))}(-[a-f0-9]+)?"))
      expect(image_element[:alt]).to eql("")
    end

    it "renders the title with the correct color and text" do
      expect(page).to have_css("h2.heading--overlap.heading--highlight-#{title_color}.heading-xl", text: title)
    end

    it "renders the text content" do
      expect(page).to have_css(".promos", text: text)
    end

    it "renders the link with correct text and href" do
      expect(page).to have_link(link_text, href: link_target)
    end
  end
end
