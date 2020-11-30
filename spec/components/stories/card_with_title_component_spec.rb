require "rails_helper"

describe Stories::CardWithTitleComponent, type: "component" do
  let :edna do
    {
      title: "Edna's career in teaching",
      image: "/images/edna-k.jpg",
    }
  end

  let :base do
    {
      name: "Edna Krabappel",
      snippet: "Your education is important. Roman numerals, et cetera",
      link: "/stories/edna-k",
      image: "/images/edna-k.jpg",
    }.with_indifferent_access
  end

  let(:story) { base }
  let(:page_data) { nil }

  subject do
    render_inline(described_class.new(card: story, page_data: page_data))
    page
  end

  it { is_expected.to have_css ".card" }
  it { is_expected.to have_css ".card.card--no-border" }
  it { is_expected.not_to have_css ".card > h3" }
  it { is_expected.to have_content story[:snippet] }

  context "With supplied title" do
    let(:story) { base.merge title: "Edna's story" }

    it { is_expected.to have_css ".card > h3" }
  end

  context "With title from stories frontmatter" do
    let(:page_data) { Pages::Data.new }

    before do
      allow(Pages::Frontmatter).to \
        receive(:find).with(story[:link]).and_return edna
    end

    it do
      is_expected.to have_css ".card > h3", text: edna[:title]
    end
  end

  context "With no title and unknown page" do
    let(:page_data) { Pages::Data.new }
    it { is_expected.not_to have_css ".card > h3" }
  end
end
