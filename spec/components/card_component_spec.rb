require "rails_helper"

describe CardComponent, type: "component" do
  let(:card) do
    {
      snippet: "Lorem ipsum ....",
      link: "/another/page",
      link_text: "Link to another page",
      image: "/images/card_thumb.jpg",
    }.with_indifferent_access
  end

  subject! { render_inline(CardComponent.new(card: card)) }

  specify "renders a card" do
    expect(page).to have_css(".card")
  end

  specify "includes a link wrapping the story image" do
    expect(page).to have_link(href: card[:link]) do |anchor|
      expect(anchor).to have_css(%(img[src='#{card[:image]}']))
    end
  end

  specify "includes the snippet" do
    expect(page).to have_content(card[:snippet])
  end

  specify "includes the linktext in the link" do
    expect(page).to have_link(card[:link_text], href: card[:link], class: "git-link")
  end

  specify "no play icon is visible" do
    expect(page).not_to have_css(".fas.fa-play")
  end

  specify "header does not show by default" do
    expect(page).not_to have_css(".card header")
  end

  specify "border shows by default" do
    expect(page).not_to have_css(".card.card--no-border")
  end

  context "with border removed" do
    let(:noborder) { card.merge(border: false) }

    subject! { render_inline(CardComponent.new(card: noborder)) }

    specify "border is removed" do
      expect(page).to have_css(".card.card--no-border")
    end
  end

  context "with header set" do
    let(:withheader) { card.merge(header: "Further info") }

    subject do
      render_inline(CardComponent.new(card: withheader))
      page
    end

    specify "header is shown" do
      is_expected.to have_css(".card header")
    end

    context "With long header" do
      let(:header) { "long " * 50 }
      let(:withheader) { card.merge header: header }
      let(:truncated) { header.truncate(described_class::MAX_HEADER_LENGTH) }

      it "will be truncated" do
        is_expected.to have_css ".card header", text: truncated
      end
    end
  end

  context "video stories" do
    let(:video) { "https://www.youtube.com/watch?v=dQw4w9WgXcQ" }
    let(:video_card) { card.merge(video: video).with_indifferent_access }

    subject! { render_inline(CardComponent.new(card: video_card)) }

    specify "the image links to the video instead of the card" do
      expect(page).to have_link(href: video_card[:video]) do |anchor|
        expect(anchor).to have_css(%(img[src='#{card[:image]}']))
      end
    end

    specify "the card has a play icon" do
      expect(page).to have_css(".fas.fa-play")
    end

    specify "the link has the required data attributes for the pop up video" do
      expect(page).to have_css(%(a[data-action='click->video#play'][data-target='video.link']))
    end
  end

  context "mistyped link_text key" do
    let(:linktext_card) { card.except(:link_text).merge(linktext: "shortened linktext") }

    subject! { render_inline(CardComponent.new(card: linktext_card)) }

    specify "still includes the link text" do
      expect(page).to have_link("shortened linktext", href: card[:link], class: "git-link")
    end
  end
end
