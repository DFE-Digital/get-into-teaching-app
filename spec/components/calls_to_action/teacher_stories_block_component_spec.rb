require "rails_helper"

RSpec.describe CallsToAction::TeacherStoriesBlockComponent, type: :component do
  let(:title) { "Teacher stories" }
  let(:image) { "teacher-stories-block-promo.jpg" }
  let(:title_color) { "pink" }
  let(:links) do
    [
      { text: "Ben's favourite thing about teaching", url: "/life-as-a-teacher/why-teach/bens-favourite-things-about-teaching" },
      { text: "Turning a tough lesson into a success", url: "/life-as-a-teacher/teaching-as-a-career/turning-a-tough-lesson-into-a-success" },
      { text: "Abigail's career progression story", url: "/life-as-a-teacher/teaching-as-a-career/abigails-career-progression-story" },
    ]
  end

  let(:kwargs) do
    {
      title: title,
      image: image,
      title_color: title_color,
      links: links,
    }
  end

  before { render_inline(described_class.new(**kwargs)) }

  describe "rendering the teacher stories block component" do
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

    it "renders the links with correct text and href" do
      links.each do |link|
        expect(page).to have_link(link[:text], href: link[:url])
      end
    end
  end
end
