require "rails_helper"
require "lazy_load_images"

describe LazyLoadImages do
  describe "#html" do
    subject { instance.html }

    let(:original_src) { "image.jpg" }
    let(:original_ext) { File.extname(original_src) }
    let(:img) { "<img class=\"test\" src=\"#{original_src}\">" }
    let(:picture) { "<picture>#{img}<source srcset=\"#{original_src}\"></source></picture>" }
    let(:instance) { described_class.new(picture) }

    it do
      lazy_image = "<img class=\"test lazyload\" src=\"#{LazyLoadImages::TINY_GIF}\" data-src=\"#{original_src}\">"
      lazy_source = "<source srcset=\"#{LazyLoadImages::TINY_GIF}\" data-srcset=\"#{original_src}\"></source>"
      is_expected.to include("<picture>#{lazy_image}<noscript>#{img}</noscript>#{lazy_source}</picture>")
    end

    context "when lazy-loading is disabled on the image" do
      let(:img) { "<img class=\"test\" src=\"#{original_src}\" data-lazy-disable=\"true\">" }

      it { is_expected.to include(picture) }
    end
  end
end
