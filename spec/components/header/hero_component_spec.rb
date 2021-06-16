require "rails_helper"

describe Header::HeroComponent, type: "component" do
  let(:front_matter) do
    {
      "title" => "Teaching, it's pretty awesome",
      "fullwidth" => true,
      "hide_page_helpful_question" => true,
      "subtitle" => "Teach all the subjects!",
      "subtitle_link" => "/signup",
      "subtitle_button" => "Find out more",
      "image" => "media/images/content/hero-images/0012.jpg",
    }
  end
  let(:component) { described_class.new(front_matter) }
  subject! { render_inline(component) }

  describe "rendering a hero section" do
    describe "title and subtitle" do
      specify "renders the title" do
        expect(page).to have_css(".hero__title > h1", text: front_matter["title"])
      end

      specify "renders the subtitle" do
        expect(page).to have_css(".hero__subtitle > .hero__subtitle__text", text: front_matter["subtitle"])
      end

      context "when a subtitle link exists" do
        let(:front_matter) do
          {
            "title" => "Teaching, it's pretty awesome",
            "subtitle" => "Teach all the subjects!",
            "subtitle_button" => "Click here to find out",
            "subtitle_link" => "https://foo.com",
            "image" => "media/images/content/hero-images/0012.jpg",
          }
        end

        subject! { render_inline(component) }

        specify "renders the subtitle button" do
          expect(page).to have_css(".hero__subtitle") do |div|
            expect(div).to have_link(front_matter["subtitle_button"], href: front_matter["subtitle_link"])
          end
        end
      end
    end

    describe "images" do
      context "when no image is present" do
        let(:component) { described_class.new(front_matter.merge("image" => nil)) }

        specify "nothing is rendered" do
          expect(rendered_component).to be_empty
        end
      end

      context "when an image is present in the front matter" do
        specify "the hero renders it" do
          expect(page).to have_css("img[data-lazy-disable=true]")
          expect(rendered_component).to match(/images\/.*[0-9a-f]+\.jpg/)
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
