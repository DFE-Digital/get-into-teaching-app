require "rails_helper"

RSpec.describe Pages::Frontmatter do
  let(:content_dir) { Rails.root.join("spec/fixtures/files/markdown_content") }
  let(:instance) { described_class.new content_dir }

  shared_examples "page loading" do
    context "with known page" do
      let(:page) { "page1" }

      it { is_expected.to include title: "Hello World 1" }
    end

    context "with nested page" do
      let(:page) { "subfolder/page2" }

      it { is_expected.to include title: "Hello World 2" }
    end

    context "with unknown page" do
      let(:page) { "unknown" }

      it "should raise an exception" do
        expect { subject }.to raise_exception Pages::Frontmatter::MissingTemplate
      end
    end
  end

  describe "#find" do
    subject { instance.find page }

    it_behaves_like "page loading"
  end

  subject "#[]" do
    subject { instance[page] }

    it_behaves_like "page loading"
  end

  describe ".find" do
    subject { described_class.find page, content_dir }

    it_behaves_like "page loading"
  end
end
