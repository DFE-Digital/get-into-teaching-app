require "rails_helper"

describe Sections::HeroComponent, type: "component" do
  let(:front_matter) do
    {
      title: "Teaching, it's pretty awesome",
      mailinglist: true,
      fullwidth: true,
      hide_page_helpful_question: true,
      subtitle: "Teach all the subjects!",
      image: "media/images/hero-home-dt.jpg",
      backlink: "/",
    }.with_indifferent_access
  end
  let(:component) { described_class.new(front_matter) }
  subject! { render_inline(component) }

  describe "rendering a hero section" do
    describe "title and subtitle" do
      specify "renders the title" do
        expect(page).to have_css(".hero__title > h1", text: front_matter[:title])
      end

      specify "renders the subtitle" do
        expect(page).to have_css(".hero__subtitle > div", text: front_matter[:subtitle])
      end
    end

    describe "images" do
      context "when no image is present" do
        let(:component) { described_class.new(front_matter.merge(image: nil)) }

        specify "nothing is rendered" do
          expect(rendered_component).to be_empty
        end
      end

      context "when an image is present in the front matter" do
        specify "the hero renders it" do
          img_tag = page.find("img.hero__img")
          img_tag[:src].match?(Regexp.new(front_matter[:image].delete_suffix(".jpg")))
        end
      end

      describe "responsive images" do
        let(:component) { described_class.new(front_matter.merge(mobileimage: "media/images/events-hero-mob.jpg")) }

        specify "the image's srcset should contain desktop and mobile" do
          img_tag = page.find("img.hero__img")

          expect(img_tag[:srcset].split(",").map { |img| img.split.last }).to match_array(%w[600w 800w])
        end
      end
    end

    describe "mailing list cta" do
      context "when mailinglist: true" do
        let(:component) { described_class.new(front_matter.merge(deepheader: true)) }

        specify "renders a mailing list strip beneath the header" do
          expect(page).to have_css(".hero__mailing-strip")
        end

        specify "the mailing list strip contains text and a button" do
          expect(page).to have_css(".hero__mailing-strip__text", text: /Sign up to receive information/)
          expect(page).to have_css(".hero__mailing-strip__cta > a.hero__mailing-strip__cta__button", text: /Sign up here/)
        end
      end
    end

    describe "rendering block content" do
      let(:sample) { "some content" }
      let(:component) do
        described_class.new(front_matter)
      end

      subject! do
        render_inline(component) { sample }
      end

      specify "the block content should be rendered by the component" do
        expect(page).to have_css(".hero__content", text: sample)
      end
    end
  end
end
