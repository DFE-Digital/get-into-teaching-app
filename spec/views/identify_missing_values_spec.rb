require "rails_helper"

describe "Monetary values checker" do
  RSpec.shared_examples "do not contain monetary values" do |files|
    let(:something) { [123] }
    it "do not contain monetary values" do
      files_and_values = files.map { |filename|
        values = File.read(filename).scan(MonetaryChecker::MONEY_REGEXP).map(&:first)
        { filename => values } if values.any?
      }.compact

      expect(files_and_values).to be_empty, "Files contain hard-coded monetary values: #{files_and_values}"
    end
  end

  describe "markdown files" do
    include_examples "do not contain monetary values", PageLister.all_md_files
  end

  describe "erb files" do
    include_examples "do not contain monetary values", PageLister.all_erb_files
  end

  describe "locale files" do
    include_examples "do not contain monetary values", PageLister.all_locale_files
  end

  describe "ruby files" do
    include_examples "do not contain monetary values", PageLister.all_ruby_files
  end
end
