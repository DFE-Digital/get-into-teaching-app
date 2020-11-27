require "rails_helper"

describe Sitemap do
  let(:markdown_root) { Rails.root.join("spec/fixtures/files/markdown_content") }
  let(:subject) { Sitemap.new(content_dir: markdown_root) }

  describe "#all_pages" do
    specify "returns all the pages present in the markdown directory" do
      expect(subject.all_pages.size).to eql(Dir.glob(markdown_root + "**/*.md").size)
    end
  end

  describe "#navbar" do
    let(:non_navigation_pages) { subject.all_pages.reject { |_p, fm| fm.dig("navigation") } }

    specify "returns the pages in the navbar format ordered by 'navigation'" do
      expect(subject.navbar.map { |item| item.dig(:front_matter, "navigation") }).to eql([10, 20, 30])
    end

    specify "doesn't include non-navigation pages" do
      expect(subject.navbar.size).to eql(subject.all_pages.size - non_navigation_pages.size)
    end
  end
end
