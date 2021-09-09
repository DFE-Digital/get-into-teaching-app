require "rails_helper"

describe Stories::CardComponent, type: "component" do
  subject do
    render_inline(described_class.new(card: story))
    page
  end

  let(:story) do
    {
      "name" => "Edna Krabappel",
      "snippet" => "Your education is important. Roman numerals, et cetera",
      "link" => "/stories/edna-k",
      "image" => "media/images/dfelogo.png",
    }
  end

  specify "renders a card" do
    is_expected.to have_css(".card")
  end

  specify "includes a link wrapping the story image" do
    is_expected.to have_link(href: story["link"]) do |anchor|
      expect(anchor).to have_css(%(img[src*="packs-test/media/images/dfelogo"]))
    end
  end

  specify "the image has descriptive alt text" do
    expect(subject).to have_css(%(img[alt="A photograph of #{story['name']}"]))
  end

  specify "includes the snippet" do
    is_expected.to have_content(story["snippet"])
  end

  specify "includes the name in a link" do
    is_expected.to have_link(%(Read #{story['name']}'s story), href: story["link"], class: "git-link")
  end

  specify "no play icon is visible" do
    is_expected.not_to have_css(".fas.fa-play")
  end

  context "with video stories" do
    subject do
      render_inline(described_class.new(card: video_story))
      page
    end

    let(:video) { "https://www.youtube.com/watch?v=dQw4w9WgXcQ" }
    let(:video_story) { story.merge("video" => video) }

    specify "the image links to the video instead of the story" do
      is_expected.to have_link(href: video_story["video"]) do |anchor|
        expect(anchor).to have_css(%(img[src*="packs-test/media/images/dfelogo"]))
      end
    end

    specify "the card has a play icon" do
      is_expected.to have_css(".fas.fa-play")
    end

    specify "the link has the required data attributes for the pop up video" do
      is_expected.to have_css(%(a[data-action='click->video#play'][data-video-target='link']))
    end
  end
end
