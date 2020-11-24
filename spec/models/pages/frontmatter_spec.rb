require "rails_helper"

RSpec.describe Pages::Frontmatter do
  let(:content_dir) { Rails.root.join("spec/fixtures/files/markdown_content") }
  let(:instance) { described_class.new content_dir }

  shared_examples "page loading" do
    context "with known page" do
      let(:page) { "/page1" }

      it { is_expected.to include title: "Hello World 1" }
    end

    context "with nested page" do
      let(:page) { "/subfolder/page2" }

      it { is_expected.to include title: "Hello World 2" }
    end

    context "with unknown page" do
      let(:page) { "/unknown" }

      it "should raise an exception" do
        expect { subject }.to raise_exception Pages::Frontmatter::MissingTemplate
      end
    end
  end

  shared_examples "a listing of all pages" do
    it { is_expected.to have_attributes keys: %w[/page1 /subfolder/page2] }
    it { is_expected.to include "/page1" => { title: "Hello World 1" } }
  end

  describe ".perform_caching" do
    subject { described_class.perform_caching }

    it { is_expected.to be false }
  end

  describe ".find" do
    subject { described_class.find page, content_dir }

    it_behaves_like "page loading"

    context "when caching" do
      before do
        allow(Pages::Frontmatter).to receive(:instance) { instance.preload }
        expect(instance).to receive(:find_from_preloaded).and_call_original
      end

      it_behaves_like "page loading"
    end
  end

  describe ".list" do
    subject { described_class.list content_dir }

    it_behaves_like "a listing of all pages"
  end

  describe "#find" do
    subject { instance.find page }

    it_behaves_like "page loading"

    context "when preloaded" do
      before do
        expect(instance).to receive(:find_from_preloaded).and_call_original
        instance.preload
      end

      it_behaves_like "page loading"
    end
  end

  subject "#[]" do
    subject { instance[page] }

    it_behaves_like "page loading"
  end

  describe "#preload" do
    subject { instance.preload.send(:templates) }

    it_behaves_like "a listing of all pages"
  end

  describe "#list" do
    subject { instance.list }

    it_behaves_like "a listing of all pages"
  end
end
