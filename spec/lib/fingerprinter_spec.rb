require "rails_helper"
require "fingerprinter"

describe Fingerprinter do
  around do |example|
    Dir.mktmpdir do |dir|
      FileUtils.copy_entry(file_fixture("fingerprinter"), dir)
      @tmp_dir = dir
      example.run
    end
  end

  let(:content_dir) { "#{@tmp_dir}/content" }
  let(:assets_dir) { "#{@tmp_dir}/assets" }

  subject { described_class.new(content_dir, assets_dir, "/assets") }

  describe "#run" do
    before { subject.run }

    let(:markdown_content) { File.read("#{content_dir}/page.md") }
    let(:partial_content) { File.read("#{content_dir}/_partial.html.erb") }

    it "renames assets to include a digest" do
      expect(Dir["#{assets_dir}/**/*.*"]).to contain_exactly(
        "#{assets_dir}/file-25be7bb30b8a1b4107c450216f0fc827e33674b6.pdf",
        "#{assets_dir}/image-94bde4207c8c55ee169e46490ed1729c2f9dcc3f.png",
        "#{assets_dir}/image-5d03ffe1412f8dcf7d037eb815520ee9b1532ed1.svg",
        "#{assets_dir}/nested/image-8405fc121b9c2321048fa612dd1189a39e8af3c3.jpg",
      )
    end

    it "generates a new digest when the file contents change" do
      expect(partial_content).to eq(
        <<~ERB,
          <%= image_tag("/assets/image-94bde4207c8c55ee169e46490ed1729c2f9dcc3f.png") %>

          <img src="/assets/nested/image-8405fc121b9c2321048fa612dd1189a39e8af3c3.jpg" />

          <%= link_to("Download a PDF", "/assets/file-25be7bb30b8a1b4107c450216f0fc827e33674b6.pdf") %>

          <div style="background-image: url('/assets/image-94bde4207c8c55ee169e46490ed1729c2f9dcc3f.png')">an image</div>

          <img src="/assets/non-existant-image.png" />
        ERB
      )
    end

    it "updates markdown content to reference the fingerprinted assets" do
      expect(markdown_content).to eq(
        <<~MARKDOWN,
          ---
            title: "A page"
            image: "/assets/image-94bde4207c8c55ee169e46490ed1729c2f9dcc3f.png"
            image_in_rails_project: "media/assets/image.png"
          ---

          Read this [document](/assets/file-25be7bb30b8a1b4107c450216f0fc827e33674b6.pdf).

          ![an image](/assets/image-94bde4207c8c55ee169e46490ed1729c2f9dcc3f.png "Look at this!")

          ![another image](/assets/image-5d03ffe1412f8dcf7d037eb815520ee9b1532ed1.svg "And this!")

          But don't read this [document](/assets/non-existant-file.pdf).
        MARKDOWN
      )
    end

    it "updates partials to reference the fingerprinted assets" do
    end
  end
end
