require "rails_helper"

RSpec.describe CallsToAction::LifeasateacherBlockComponent, type: :component do
  let(:title) { "Life as a teacher" }
  let(:image) { "life-as-a-teacher-block-promo.jpg" }
  let(:title_color) { "blue" }
  let(:links) { [
    { text: "Pay and benefits", url: "/life-as-a-teacher/pay-and-benefits" },
    { text: "Why teach", url: "/life-as-a-teacher/why-teach" },
    { text: "Teaching as a career", url: "/life-as-a-teacher/teaching-as-a-career" },
    { text: "Explore subjects you could teach", url: "/life-as-a-teacher/explore-subjects" },
    { text: "Age groups and specialisms", url: "/life-as-a-teacher/age-groups-and-specialisms" },
    { text: "Change to a career in teaching", url: "/life-as-a-teacher/change-careers" },
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

  describe "rendering the lifeasateacher block component" do
    it "renders the outer div with class 'image-block'" do
      expect(page).to have_css("div.image-block")
    end

    it "renders the image with correct src and alt text" do
      image_element = page.find("img")
      expect(image_element[:src]).to match(Regexp.new("images/#{Regexp.escape(File.basename(image, '.*'))}(-[a-f0-9]+)?"))
      expect(image_element[:alt]).to eql("Life as a teacher icon")
    end

    it "renders the title with the correct color and text" do
      expect(page).to have_css("h2.heading--overlap.heading--highlight-#{title_color}.heading-xl", text: title)
    end

    it "renders the links with correct text and href" do
      links.each do |link|
        expect(page).to have_link(link[:text], href: link[:url])
      end
    end
