require "rails_helper"

RSpec.describe Pages::Frontmatter do
  let(:content_dir) { Rails.root.join "spec/fixtures/files/markdown_content" }
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
        expect { subject }.to raise_exception Pages::Frontmatter::NotMarkdownTemplate
      end
    end
  end

  shared_examples "a listing of all pages" do
    it "includes all pages" do
      expect(subject.keys).to match_array(%w[/page1 /subfolder/page2])
    end

    it { is_expected.to include "/page1" => { title: "Hello World 1" } }
  end

  describe ".perform_caching" do
    subject { described_class.send :perform_caching }

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

  describe ".select" do
    subject { described_class.select :title, content_dir }

    before { expect_any_instance_of(described_class).to receive(:select).and_call_original }

    it { is_expected.to include "/page1" }
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
    subject { instance.preload.send(:frontmatter) }

    it_behaves_like "a listing of all pages"
  end

  describe "#list" do
    subject { instance.list }

    it_behaves_like "a listing of all pages"
  end

  describe "#select" do
    let :content_dir do
      {
        "/first" => { priority: 10, section: "stories", first: "First" },
        "/second" => { priority: 20 },
        "/third" => { priority: 30, section: "stories" },
      }
    end

    context "stories with matching key" do
      subject { instance.select :section }

      it { is_expected.to include "/first" }
      it { is_expected.not_to include "/second" }
      it { is_expected.to include "/third" }
    end

    context "stories with matching key and value" do
      subject { instance.select section: "stories" }

      it { is_expected.to include "/first" }
      it { is_expected.not_to include "/second" }
      it { is_expected.to include "/third" }
    end

    context "with multiple keys and values" do
      subject { instance.select section: "stories", priority: 30 }

      it { is_expected.not_to include "/first" }
      it { is_expected.not_to include "/second" }
      it { is_expected.to include "/third" }
    end

    context "with an unexpected selector type" do
      subject { instance.select 1 }

      it { expect { subject }.to raise_exception described_class::UnknownSelectorType }
    end
  end
end
