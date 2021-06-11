require "rails_helper"

describe CardComponent, type: "component" do
  let(:base) do
    {
      "snippet" => "Lorem ipsum ....",
      "link" => "/another/page",
      "link_text" => "Link to another page",
      "image" => "media/images/dfelogo.png",
      "image_description" => "A thorough description of the image",
    }
  end

  let(:card) { base }

  subject do
    render_inline described_class.new(card: card)
    page
  end

  specify "renders a card" do
    is_expected.to have_css(".card")
  end

  specify "includes a link wrapping the story image" do
    is_expected.to have_link(href: card["link"]) do |anchor|
      expect(anchor).to have_css(%(img[src*="packs-test/media/images/dfelogo"]))
    end
  end

  specify "sets the image's alt text" do
    is_expected.to have_css(%(img[alt="#{card['image_description']}"]))
  end

  specify "includes the snippet" do
    is_expected.to have_content(card["snippet"])
  end

  specify "includes the linktext in the link" do
    is_expected.to have_link(card["link_text"], href: card["link"], class: "git-link")
  end

  specify "no play icon is visible" do
    is_expected.not_to have_css(".fas.fa-play")
  end

  specify "header does not show by default" do
    is_expected.not_to have_css(".card header")
  end

  specify "border shows by default" do
    is_expected.not_to have_css(".card.card--no-border")
  end

  context "with border removed" do
    let(:card) { base.merge("border" => false) }

    specify "border is removed" do
      is_expected.to have_css(".card.card--no-border")
    end
  end

  context "with header set" do
    let(:card) { base.merge("header" => "Further info") }

    specify "header is shown" do
      is_expected.to have_css(".card header", text: "Further info")
    end

    context "with long header" do
      let(:header) { "long " * 50 }
      let(:card) { base.merge("header" => header) }
      let(:truncated) { header.truncate(described_class::MAX_HEADER_LENGTH) }

      it "will be truncated" do
        is_expected.to have_css ".card header", text: truncated
      end
    end
  end

  context "with title set" do
    let(:title) { "a title" }
    let(:card) { base.merge("title" => title) }

    specify "title is shown" do
      is_expected.to have_css(".card > h3", text: "a title")
    end
  end

  context "with video story" do
    let(:video) { "https://www.youtube.com/watch?v=dQw4w9WgXcQ" }
    let(:card) { base.merge("video" => video) }

    specify "the image links to the video instead of the card" do
      is_expected.to have_link(href: card["video"]) do |anchor|
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

  context "with mistyped link_text key" do
    let(:card) { base.except("link_text").merge("linktext" => "shortened linktext") }

    specify "still includes the link text" do
      is_expected.to have_link("shortened linktext", href: card["link"], class: "git-link")
    end
  end

  context "when no image_description is provided" do
    let(:card) { base.merge("image_description" => nil) }

    it "has no image description attribute" do
      expect(subject.find("img")["alt"]).to be_nil
    end
  end
end
