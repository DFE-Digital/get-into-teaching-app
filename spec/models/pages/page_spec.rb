require "rails_helper"

RSpec.describe Pages::Page do
  include_context "use fixture markdown pages"

  shared_examples "a page" do |title, path, template|
    it { is_expected.to be_instance_of described_class }
    it { is_expected.to have_attributes title: title }
    it { is_expected.to have_attributes path: path }
    it { is_expected.to have_attributes template: template }
    it { is_expected.to have_attributes data: instance_of(Pages::Data) }
  end

  describe ".find" do
    context "with markdown page" do
      subject { described_class.find "/page1" }

      it_behaves_like "a page", "Hello World 1", "/page1", "content/page1"
    end

    context "with non markdown page" do
      it "raises an exception" do
        expect { described_class.find "/unknown" }.to raise_error(Pages::Page::PageNotFoundError)
      end
    end
  end

  describe ".featured" do
    subject { described_class.featured }

    it_behaves_like "a page", "Hello World 1", "/page1", "content/page1"

    context "with multiple featured stories" do
      before { allow(Pages::Frontmatter).to receive(:select).and_return pages }

      let(:pages) do
        {
          "/stories/featured" => { featured: true, title: "Featured page" },
          "/stories/second" => { featured: true, title: "Second page" },
        }
      end

      it { expect { subject }.to raise_exception Pages::Page::MultipleFeatured }
    end
  end

  describe "#parent" do
    subject { described_class.find(path).parent&.path }

    context "when the home page" do
      let(:path) { "/home" }

      it { is_expected.to be_nil }
    end

    context "when a top-level page" do
      let(:path) { "/first" }

      it { is_expected.to be_nil }
    end

    context "when a sub-page" do
      context "when the sub-page has a parent" do
        let(:path) { "/story-section/story-listing" }

        it { is_expected.to eq("/story-section") }
      end

      context "when the sub-page does not have an immediate parent" do
        let(:path) { "/story-section/story-listing/other-story/story" }

        it { is_expected.to eq("/story-section/story-listing") }
      end
    end
  end

  describe "#ancestors" do
    subject { described_class.find(path).ancestors.map(&:path) }

    context "when the home page" do
      let(:path) { "/home" }

      it { is_expected.to be_empty }
    end

    context "when a top-level page" do
      let(:path) { "/first" }

      it { is_expected.to be_empty }
    end

    context "when a sub-page" do
      context "when the sub-page has a parent" do
        let(:path) { "/story-section/story-listing" }

        it { is_expected.to eq(["/story-section"]) }
      end

      context "when the sub-page does not have an immediate parent" do
        let(:path) { "/story-section/story-listing/other-story/story" }

        it { is_expected.to eq(["/story-section/story-listing", "/story-section"]) }
      end
    end
  end
end
