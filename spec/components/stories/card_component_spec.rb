require "rails_helper"

describe Stories::CardComponent, type: "component" do
  let(:story) do
    {
      name: "Edna Krabappel",
      snippet: "Your education is important. Roman numerals, et cetera",
      link: "/stories/edna-k",
      image: "/images/edna-k.jpg",
    }.with_indifferent_access
  end

  subject! { render_inline(Stories::CardComponent.new(card: story)) }

  specify "renders a card" do
    expect(page).to have_css(".story-card")
  end

  specify "includes a link wrapping the story image" do
    expect(page).to have_link(href: story[:link]) do |anchor|
      expect(anchor).to have_css(%(img[src='#{story[:image]}']))
    end
  end

  specify "includes the snippet" do
    expect(page).to have_content(story[:snippet])
  end

  specify "includes the name in a link" do
    expect(page).to have_link(%(Read #{story[:name]}'s story), href: story[:link], class: "git-link")
  end

  specify "no play icon is visible" do
    expect(page).not_to have_css(".fas.fa-play")
  end

  context "video stories" do
    let(:video) { "https://www.youtube.com/watch?v=dQw4w9WgXcQ" }
    let(:video_story) { story.merge(video: video).with_indifferent_access }

    subject! { render_inline(Stories::CardComponent.new(card: video_story)) }

    specify "the image links to the video instead of the story" do
      expect(page).to have_link(href: video_story[:video]) do |anchor|
        expect(anchor).to have_css(%(img[src='#{story[:image]}']))
      end
    end

    specify "the card has a play icon" do
      expect(page).to have_css(".fas.fa-play")
    end

    specify "the link has the required data attributes for the pop up video" do
      expect(page).to have_css(%(a[data-action='click->video#play'][data-target='video.link']))
    end
  end
end
