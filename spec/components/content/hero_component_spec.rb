require "rails_helper"

describe Content::HeroComponent, type: "component" do
  subject! { render_inline(component) }

  let(:extra_front_matter) { {} }
  let(:front_matter) do
    {
      "title" => "Teaching, it's pretty awesome",
      "fullwidth" => true,
      "hide_page_helpful_question" => true,
      "subtitle" => "Teach all the subjects!",
      "subtitle_link" => "/signup",
      "subtitle_button" => "Find out more",
      "image" => "media/images/content/hero-images/0012.jpg",
    }.merge(extra_front_matter)
  end
  let(:component) { described_class.new(front_matter) }

  describe "rendering a hero section" do
    describe "content blending" do
      context "when the hero is set to blend with the content" do
        let(:extra_front_matter) { { "hero_blend_content" => true } }

        specify "renders the hero with the content blended in" do
          expect(page).to have_css(".hero.blend-content")
        end
      end
    end

    describe "background" do
      specify "renders with a grey background" do
        expect(page).to have_css(".hero.grey")
      end

      context "when the hero background is overriden" do
        let(:extra_front_matter) { { "hero_bg_color" => "white" } }

        specify "renders the hero with the color class" do
          expect(page).to have_css(".hero.white")
        end
      end
    end

    describe "title and subtitle" do
      specify "renders the title in a h1 element with a yellow background" do
        expect(page).to have_css(".hero__title.yellow > h1", text: front_matter["title"])
      end

      context "when the heading overrides the title" do
        let(:extra_front_matter) { { "heading" => "Here's my custom heading" } }

        specify "renders the heading in a h1 element" do
          expect(page).to have_css(".hero__title > h1", text: front_matter["heading"])
        end
      end

      context "when the title background is overriden" do
        let(:extra_front_matter) { { "title_bg_color" => "white" } }

        specify "renders the heading with the color class" do
          expect(page).to have_css(".hero__title.white > h1", text: front_matter["heading"])
        end
      end

      specify "renders the subtitle" do
        expect(page).to have_css(".hero__subtitle > .hero__subtitle__text", text: front_matter["subtitle"])
      end

      context "when a subtitle link exists" do
        subject! { render_inline(component) }

        let(:front_matter) do
          {
            "title" => "Teaching, it's pretty awesome",
            "subtitle" => "Teach all the subjects!",
            "subtitle_button" => "Click here to find out",
            "subtitle_link" => "https://foo.com",
            "image" => "media/images/content/hero-images/0012.jpg",
          }
        end

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
      subject! do
        render_inline(component) { sample }
      end

      let(:sample) { "some content" }
      let(:component) do
        described_class.new(front_matter)
      end

      specify "the block content should be rendered by the component" do
        expect(page).to have_css(".hero__content", text: sample)
      end
    end

    describe "rendering a title paragraph" do
      subject! do
        render_inline(component) { sample }
      end

      let(:sample) { "Some paragraph text" }
      let(:component) do
        described_class.new(front_matter.merge(title_paragraph: sample))
      end

      specify "the paragraph should be rendered by the component" do
        expect(page).to have_css(".hero__paragraph", text: sample)
      end
    end
  end
end
