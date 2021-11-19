require "rails_helper"

RSpec.describe ::Pages::Page do
  include_context "with fixture markdown pages"

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

      it_behaves_like "a page", "Hello World 1 Upwards", "/page1", "content/page1"
    end

    context "with non markdown page" do
      it "raises an exception" do
        expect { described_class.find "/unknown" }.to raise_error(::Pages::Page::PageNotFoundError)
      end
    end
  end

  describe ".featured" do
    subject { described_class.featured }

    it_behaves_like "a page", "Hello World 1 Upwards", "/page1", "content/page1"

    context "with multiple featured stories" do
      before { allow(Pages::Frontmatter).to receive(:select).and_return pages }

      let(:pages) do
        {
          "/stories/featured" => { featured: true, title: "Featured page" },
          "/stories/second" => { featured: true, title: "Second page" },
        }
      end

      it { expect { subject }.to raise_exception ::Pages::Page::MultipleFeatured }
    end
  end

  describe "#parent" do
    context "when the page depth does not exceed the max traversal depth" do
      subject { described_class.find(path).parent&.path }

      context "when a top-level page" do
        let(:path) { "/first" }

        it { is_expected.to be_nil }
      end

      context "when a sub-page" do
        context "when the sub-page has a parent" do
          let(:path) { "/subfolder/page2" }

          it { is_expected.to eq("/subfolder") }
        end

        context "when the sub-page does not have an immediate parent" do
          let(:path) { "/subfolder/transient/page3" }

          it { is_expected.to eq("/subfolder") }
        end
      end
    end

    context "when the page depth exceeds the max traversal depth" do
      let(:deep_path) { (described_class::MAX_TRAVERSAL_DEPTH + 5).times.collect { "/path" }.join }

      before do
        page = described_class.find("/subfolder/page2")
        allow(page).to receive(:path) { deep_path }
        allow(described_class).to receive(:find).and_raise(described_class::PageNotFoundError)
        page.parent
      end

      it "only tries to traverse to a maximum depth of #{described_class::MAX_TRAVERSAL_DEPTH}" do
        expect(described_class).to have_received(:find).exactly(described_class::MAX_TRAVERSAL_DEPTH).times
      end
    end
  end

  describe "#ancestors" do
    context "when the page depth does not exceed the max traversal depth" do
      subject { described_class.find(path).ancestors.map(&:path) }

      context "when a top-level page" do
        let(:path) { "/first" }

        it { is_expected.to be_empty }
      end

      context "when a sub-page" do
        context "when the sub-page has a parent" do
          let(:path) { "/subfolder/page2" }

          it { is_expected.to eq(["/subfolder"]) }
        end

        context "when the sub-page has multiple parents" do
          let(:path) { "/subfolder/other/page4" }

          it { is_expected.to eq(["/subfolder/other", "/subfolder"]) }
        end
      end
    end

    context "when the page depth exceeds the max traversal depth" do
      let(:page) { described_class.find("/subfolder/page2") }

      it "only tries to traverse to a maximum depth of #{described_class::MAX_TRAVERSAL_DEPTH}" do
        expect(page).to receive(:parent).exactly(described_class::MAX_TRAVERSAL_DEPTH).times.and_return(page)
        page.ancestors
      end
    end
  end
end
