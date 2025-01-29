require "rails_helper"

RSpec.describe Content::CallToActionComponentInjector, type: :component do
  {
    "simple component" => {
      "name" => "simple",
      "arguments" => {
        "title" => "simple component",
        "link_target" => "#simple-component",
        "link_text" => "simple component link",
        "icon" => "icon-person",
      },
    },
    "find component" => {
      "name" => "find",
      "arguments" => {
        "title" => "find component",
        "link_target" => "#find-component",
        "link_text" => "find component link",
        "icon" => "icon-person",
      },
    },
    "apply component" => {
      "name" => "find",
      "arguments" => {
        "title" => "find component",
        "link_target" => "#find-component",
        "link_text" => "find component link",
        "icon" => "icon-person",
      },
    },
    "attachment component" => {
      "name" => "attachment",
      "arguments" => {
        "text" => "Text",
        "file_path" => "static/documents/bringit-report.pdf",
        "file_type" => "PDF",
        "published_at" => "01 September 2020",
      },
    },
    "chat component" => "chat",
    "feature table component" => {
      "name" => "feature_table",
      "arguments" => [
        { "Row 1" => "Value 1" },
        { "title" => "Title" },
      ],
    },
  }.each do |name, meta|
    describe "rendering a #{name}" do
      subject { described_class.new(meta).component }

      specify "generates a view component from the arguments" do
        is_expected.to be_a(ViewComponent::Base)
      end
    end
  end

  context "with invalid arguments" do
    let(:invalid_args) do
      { "story component" => { "name" => "story", "arguments" => { "something" => "story component" } } }
    end

    specify "raises an error describing bad config of the component" do
      expect { described_class.new(invalid_args).component }.to raise_error(ArgumentError, /call to action not properly configured/)
    end
  end

  context "with non-Array/Hash arguments" do
    let(:invalid_args) { { "arguments" => 123 } }

    it "raises an ArgumentError" do
      expect { described_class.new(invalid_args).component }.to raise_error(ArgumentError, /call to action not properly configured/)
    end
  end
end
