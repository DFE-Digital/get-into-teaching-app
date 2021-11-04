require "rails_helper"
require "responsive_images"

describe ResponsiveImages do
  describe "#html" do
    subject { instance.html }

    let(:fingerprint) { "-fingerprint1" }
    let(:asset_host) { "" }
    let(:src) { "#{asset_host}/media/images/content/an-image#{fingerprint}.jpg" }
    let(:body) do
      "<picture>
        <source srcset=\"#{src}\" type=\"image/jpeg\"></source>
        <img src=\"#{src}\">
      </picture>"
    end
    let(:instance) { described_class.new(body) }

    before { allow(Dir).to receive(:glob).and_call_original }

    it { is_expected.to include(body) }

    described_class::BREAKPOINTS.each do |breakpoint, max_width|
      context "when a #{breakpoint} image exists" do
        let!(:responsive_src) { setup_responsive_img(breakpoint) }

        it do
          is_expected.to include(
            "<source srcset=\"#{responsive_src}\" type=\"image/jpeg\" media=\"(max-width: #{max_width})\"></source>",
          )
        end

        context "when the src is absolute (assets are hosted on a different domain)" do
          let(:asset_host) { "https://domain.com" }

          it do
            is_expected.to include(
              "<source srcset=\"#{responsive_src}\" type=\"image/jpeg\" media=\"(max-width: #{max_width})\"></source>",
            )
          end
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
    responsive_src = "media/images/content/an-image--#{breakpoint}-#{fingerprint}.jpg"
    public_path = Rails.public_path
    responsive_file = "#{public_path}/#{responsive_src}"
    responsive_pattern = "#{public_path}/media/images/content/an-image--#{breakpoint}*.jpg"

    allow(Dir).to receive(:glob).with(responsive_pattern) { [responsive_file] }

    "#{asset_host}/#{responsive_src}"
  end
end
