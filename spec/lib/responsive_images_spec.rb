require "rails_helper"
require "responsive_images"

describe ResponsiveImages do
  describe "#html" do
    let(:fingerprint) { "-fingerprint1" }
    let(:src) { "/assets/images/an-image#{fingerprint}.jpg" }
    let(:body) do
      "<picture>
        <source srcset=\"#{src}\" type=\"image/jpeg\"></source>
        <img src=\"#{src}\">
      </picture>"
    end
    let(:instance) { described_class.new(body) }

    before { allow(Dir).to receive(:glob).and_call_original }

    subject { instance.html }

    it { is_expected.to include(body) }

    described_class::BREAKPOINTS.each do |breakpoint, max_width|
      context "when a #{breakpoint} image exists" do
        let!(:responsive_src) { setup_responsive_img(breakpoint) }

        it do
          is_expected.to include(
            "<source srcset=\"#{responsive_src}\" type=\"image/jpeg\" media=\"(max-width: #{max_width})\"></source>",
          )
        end
      end
    end

    context "when multiple responsive images exist" do
      let!(:tablet_src) { setup_responsive_img(:tablet) }
      let!(:mobile_src) { setup_responsive_img(:mobile) }

      it "renders smallest <source> first" do
        is_expected.to include(
          "<source srcset=\"#{mobile_src}\" type=\"image/jpeg\" media=\"(max-width: 500px)\"></source>" \
          "<source srcset=\"#{tablet_src}\" type=\"image/jpeg\" media=\"(max-width: 768px)\"></source>",
        )
      end
    end

    context "when fingerprinting is disabled (in development)" do
      let(:fingerprint) { "" }
      let!(:responsive_src) { setup_responsive_img(:mobile) }

      before { allow(Rails).to receive(:env) { "development".inquiry } }

      it do
        is_expected.to include(
          "<source srcset=\"#{responsive_src}\" type=\"image/jpeg\" media=\"(max-width: 500px)\"></source>", \
        )
      end
    end
  end

  def setup_responsive_img(breakpoint)
    fingerprint = "1234abc"
    responsive_src = "/assets/images/an-image--#{breakpoint}-#{fingerprint}.jpg"
    responsive_file = "#{Rails.public_path}#{responsive_src}"
    responsive_pattern = "#{Rails.public_path}/assets/images/an-image--#{breakpoint}*.jpg"

    allow(Dir).to receive(:glob).with(responsive_pattern) { [responsive_file] }

    responsive_src
  end
end
