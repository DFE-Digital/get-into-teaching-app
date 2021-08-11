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

  describe "#root_page?" do
    {
      "/" => true,
      "/one" => true,
      "/one/two" => false,
      "/one/two/three" => false,
    }.each do |path, expected_result|
      context "path: #{path}" do
        specify "returns #{expected_result}" do
          expect(root_page?(path)).to be expected_result
        end
      end
    end
  end
end
