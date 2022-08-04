require "rails_helper"
require "image_sizes"

describe ImageSizes do
  include ActionView::Helpers
  include Webpacker::Helper

  describe "#html" do
    subject(:render_html) { instance.html }

    let(:src_url) { "http://example.com/a/test/image.jpg" }
    let(:fast_image_url) { src_url }
    let(:body) { %(<img src="#{src_url}">) }
    let(:instance) { described_class.new(body) }

    before do
      described_class.class_variable_set(:@@cache, {})
      allow(FastImage).to receive(:size)
        .with(fast_image_url, raise_on_failure: false, timeout: 1).and_return([500, 800])
    end

    it { is_expected.to include(%(width="500" height="800")) }

    context "when the image cannot be found" do
      before { allow(FastImage).to receive(:size).and_return(nil) }

      it { is_expected.to include(body) }
    end

    context "when the image already has a size" do
      let(:body) { %(<img src="#{src_url}" width="10" height="10">) }

      it { is_expected.to include(body) }
    end

    context "when the image only has a width" do
      let(:body) { %(<img src="#{src_url}" width="500">) }

      it { is_expected.to include(%(<img src="#{src_url}" width="500" height="800">)) }
    end

    context "when the image only has a height" do
      let(:body) { %(<img src="#{src_url}" height="800">) }

      it { is_expected.to include(%(<img src="#{src_url}" height="800" width="500">)) }
    end

    context "when the img src is a path" do
      let(:src_url) { "/a/test/image.png" }
      let(:fast_image_url) { "public#{src_url}" }

      it "loads the file from the public/ directory" do
        is_expected.to include(%(<img src="#{src_url}" width="500" height="800">))
      end
    end

    context "when the same image is found multiple times" do
      let(:body) { %(<img src="#{src_url}"><img src="#{src_url}">) }

      it "sets the size for both images" do
        is_expected.to include(
          %(<img src="#{src_url}" width="500" height="800"><img src="#{src_url}" width="500" height="800">),
        )
      end

      it "caches the image sizes" do
        render_html
        expect(FastImage).to have_received(:size).once
      end
    end
  end
end
