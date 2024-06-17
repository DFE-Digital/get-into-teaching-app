require "rails_helper"

RSpec.feature "Check files", type: :feature do
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
    include_examples "do not contain monetary values", PageLister.md_files_including_partials
  end

  describe "html files" do
    include_examples "do not contain monetary values", PageLister.html_files_including_partials
  end
end
