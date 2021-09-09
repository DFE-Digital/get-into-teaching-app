require "rails_helper"
require "next_gen_images"

describe NextGenImages do
  describe "#html" do
    subject { instance.html }

    let(:original_ext) { File.extname(original_src) }
    let(:body) { "<img src=\"#{original_src}\">" }
    let(:instance) { described_class.new(body) }

    before { allow(File).to receive(:exist?) { false } }

    before { allow(File).to receive(:exist?).with("#{Rails.public_path}/#{original_src}") { true } }

    context "when the original image is a jpg" do
      let(:original_src) { "path/to/image.jpg" }

      context "when there are no next-gen images" do
        it { is_expected.to include("<picture>#{source(original_src, 'image/jpeg')}<img src=\"#{original_src}\"></picture>") }
      end

      context "when the image is already in a picture tag" do
        let(:body) { "<picture><img src=\"#{original_src}\"></picture>" }

        it { is_expected.to include(body) }
      end

      context "when there are next-gen images" do
        let(:next_gen_imgs) do
          {
            "image/webp" => original_src.gsub(original_ext, ".webp"),
            "image/jp2" => original_src.gsub(original_ext, ".jp2"),
            "image/jpeg" => original_src,
          }
        end

        before do
          next_gen_imgs.values.each do |src|
            allow(File).to receive(:exist?).with("#{Rails.public_path}/#{src}") { true }
          end
        end

        it do
          sources = next_gen_imgs.map { |mime_type, src| source(src, mime_type) }.join
          is_expected.to include("<picture>#{sources}<img src=\"#{original_src}\"></picture>")
        end
      end
    end

    context "when the original image is a png" do
      let(:original_src) { "path/to/image.png" }

      it { is_expected.to include("<picture>#{source(original_src, 'image/png')}<img src=\"#{original_src}\"></picture>") }
    end

    context "when the original image is an svg" do
      let(:original_src) { "path/to/image.svg" }

      it { is_expected.to include("<picture>#{source(original_src, 'image/svg+xml')}<img src=\"#{original_src}\"></picture>") }
    end
  end

  def source(src, mime_type)
    "<source srcset=\"#{src}\" type=\"#{mime_type}\"></source>"
  end
end
