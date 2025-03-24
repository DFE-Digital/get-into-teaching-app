require "rails_helper"

RSpec.describe CallsToAction::ApplyBlockComponent, type: :component do
  let(:title) { "Start your application" }
  let(:image) { "apply-block-promo.jpg" }
  let(:title_color) { "green" }
  let(:text) { "Create an account and start your application for a teacher training course." }
  let(:link_text) { "Apply for a course" }
  let(:link_target) { "https://www.gov.uk/apply-for-teacher-training" }

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

  describe "rendering the apply block component" do
    it "renders the outer div with class 'image-block'" do
      expect(page).to have_css("div.image-block")
    end

    it "renders the image with correct src and alt text" do
      image_element = page.find("img")
      expect(image_element[:src]).to match(Regexp.new("images/#{Regexp.escape(File.basename(image, '.*'))}(-[a-f0-9]+)?"))
      expect(image_element[:alt]).to eql("Apply icon")
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
