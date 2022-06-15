require "rails_helper"

describe ContentHelper, type: :helper do
  describe "#article_classes" do
    subject { article_classes(front_matter) }

    context "with no arguments" do
      let(:front_matter) { {} }

      it %(returns an array containing only "markdown") do
        expect(subject).to match_array(%w[markdown])
      end
    end

    context "when fullwidth is true" do
      let(:front_matter) { { "fullwidth" => true } }

      it %(returns an array containing "markdown" and "fullwidth") do
        expect(subject).to match_array(%w[markdown fullwidth])
      end
    end

    context "when article_classes are provided" do
      let(:custom_classes) { %w[super-important big-headings] }
      let(:front_matter) { { "article_classes" => custom_classes } }

      it %(returns an array containing "markdown" and the extra custom classes) do
        expect(subject).to match_array(%w[markdown].concat(custom_classes))
      end
    end
  end

  describe "#display_content_errors?" do
    before { allow(Rails.application.config.x).to receive(:display_content_errors).and_return(false) }

    subject { display_content_errors? }

    it { is_expected.to be(false) }

    context "when config is set to true" do
      before { allow(Rails.application.config.x).to receive(:display_content_errors).and_return(true) }

      it { is_expected.to be(true) }
    end
  end
end
