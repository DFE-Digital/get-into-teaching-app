require "rails_helper"

RSpec.describe CallsToAction::RoutesBlockComponent, type: :component do
  let(:title) { "Find your route into teaching" }
  let(:image) { "routes-block-promo.jpg" }
  let(:title_color) { "yellow" }
  let(:text) { "Answer 3 questions and find routes into teaching based on your circumstances." }
  let(:link_text) { "Find a route" }
  let(:link_target) { "/routes-into-teaching" }

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

  describe "rendering the routes block component" do
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
