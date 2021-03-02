require "rails_helper"

describe Cards::StoryComponent, type: "component" do
  let :edna do
    {
      title: "Edna's career in teaching",
      image: "/images/edna-k.jpg",
    }
  end

  let :base do
    {
      "name" => "Edna Krabappel",
      "snippet" => "Your education is important. Roman numerals, et cetera",
      "link" => "/stories/edna-k",
      "image" => "/images/edna-k.jpg",
    }
  end

  let(:story) { base }
  let(:page_data) { nil }

  subject do
    render_inline(described_class.new(card: story, page_data: page_data))
    page
  end

  it { is_expected.to have_css ".card" }
  it { is_expected.to have_css ".card.card--no-border" }
  it { is_expected.not_to have_css ".card header" }
  it { is_expected.to have_css "img[src=\"#{story['image']}\"]" }
  it { is_expected.to have_content story["snippet"] }

  specify "includes the name in a link" do
    is_expected.to have_link(%(Read #{story['name']}'s story), href: story["link"], class: "git-link")
  end

  context "with supplied header" do
    let(:story) { base.merge "header" => "Edna's story" }

    it { is_expected.to have_css ".card header" }
  end

  context "with header from stories frontmatter" do
    let(:page_data) { Pages::Data.new }
    let(:truncated) { edna[:title].truncate described_class::MAX_HEADER_LENGTH }

    before do
      allow(Pages::Frontmatter).to \
        receive(:find).with(story["link"]).and_return edna
    end

    it do
      is_expected.to have_css ".card header", text: truncated
    end
  end

  context "with no header and unknown page" do
    let(:page_data) { Pages::Data.new }
    it { is_expected.not_to have_css ".card header" }
  end
end
