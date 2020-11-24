require "rails_helper"

describe Sections::HeaderComponent, type: "component" do
  let(:front_matter) do
    {
      title: "Teaching, it's pretty awesome",
      image: "media/images/hero-home-dt.jpg",
    }.with_indifferent_access
  end

  let(:component) { Sections::HeaderComponent.new(front_matter) }
  subject! { render_inline(component) }

  describe "rendering a header section" do
    specify "renders the title" do
      expect(page).to have_css(".header__title > h1", text: front_matter[:title])
    end

    specify "renders an the image" do
      img_tag = page.find(".header__img > img")
      img_tag[:src].match?(Regexp.new(front_matter[:image].delete_suffix(".jpg")))
    end

    describe "responsive images" do
      let(:component) { Sections::HeaderComponent.new(front_matter.merge(mobileimage: "media/images/events-hero-mob.jpg")) }

      specify "the image's srcset should contain desktop and mobile" do
        img_tag = page.find(".header__img > img")

        expect(img_tag[:srcset].split(",").map { |img| img.split.last }).to match_array(%w[600w 800w])
      end
    end
  end
end
