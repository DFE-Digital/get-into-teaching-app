require "rails_helper"

RSpec.describe Cards::FeaturedStoryComponent, type: :component do
  subject { render_inline(instance) && page }

  let :original do
    {
      title: "Page title",
      image: "/test.jpg",
      featured_story_card: true,
      story: { "name" => "Teacher" },
    }
  end

  let(:frontmatter) { original }
  let(:featured_page) { Pages::Page.new "/stories/featured", frontmatter }
  let(:page_data) { Pages::Data.new }
  let(:instance) { described_class.new card: {}, page_data: page_data }

  before { allow(Pages::Page).to receive(:featured).and_return featured_page }

  it { is_expected.to have_css ".card" }
  it { is_expected.to have_css ".card.card--no-border" }
  it { is_expected.to have_css ".card header", text: "Teacher's story" }
  it { is_expected.to have_css 'img[src="/test.jpg"]' }
  it { is_expected.to have_content "Page title" }

  it "includes the footer link" do
    is_expected.to have_link \
      "Read Teacher's story",
      href: "/stories/featured",
      class: "git-link"
  end

  context "With different title" do
    let(:frontmatter) do
      original.deep_merge featured_story_card: { "title" => "Featured" }
    end

    it { is_expected.to have_css ".card" }
    it { is_expected.to have_css ".card.card--no-border" }
    it { is_expected.to have_css ".card header", text: "Featured" }
    it { is_expected.to have_css "img" }
    it { is_expected.to have_content "Page title" }
  end

  context "Without snippet" do
    let(:frontmatter) { original.without :title }

    it { expect { subject }.to raise_exception described_class::MissingTitleOnFeatured }
  end

  context "Without featured story" do
    let(:featured_page) { nil }

    it { expect { subject }.to raise_exception described_class::NoFeaturedStory }
  end
end
