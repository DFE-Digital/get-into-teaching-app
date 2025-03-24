require "rails_helper"

RSpec.describe CallsToAction::GetSupportBlockComponent, type: :component do
  let(:title) { "Get free support" }
  let(:image) { "get-support-block-promo.jpg" }
  let(:title_color) { "yellow" }
  let(:links) { [
    { text: "Get an adviser", url: "/teacher-training-adviser/sign_up/identity" },
    { text: "Attend a Get Into Teaching event", url: "/events/about-get-into-teaching-events" },
    { text: "Get tailored email advice", url: "/mailinglist/signup/name" },
    { text: "Get school experience", url: "/train-to-be-a-teacher/get-school-experience" },
  ] }


  let(:kwargs) do
    {
      title: title,
      image: image,
      title_color: title_color,
      links: links,
    }
  end

  before { render_inline(described_class.new(**kwargs)) }

  describe "rendering the get support block component" do
    it "renders the outer div with class 'image-block'" do
      expect(page).to have_css("div.image-block")
    end

    it "renders the image with correct src and alt text" do
      image_element = page.find("img")
      expect(image_element[:src]).to match(Regexp.new("images/#{Regexp.escape(File.basename(image, '.*'))}(-[a-f0-9]+)?"))
      expect(image_element[:alt]).to eql("Get support icon")
    end

    it "renders the title with the correct color and text" do
      expect(page).to have_css("h2.heading--overlap.heading--highlight-#{title_color}.heading-xl", text: title)
    end

    it "renders the links with correct text and href" do
      links.each do |link|
        expect(page).to have_link(link[:text], href: link[:url])
      end
    end
end
