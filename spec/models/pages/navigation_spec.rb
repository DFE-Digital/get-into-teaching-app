require "rails_helper"

describe Pages::Navigation do
  let(:child_pages) do
    {
      "/content/page_3/subpage_3_1" => { title: "Page 3.1", parent: { path: "/content/page_3", navigation: 35 } },
      "/content/page_3/subpage_3_2" => { title: "Page 3.2", parent: { path: "/content/page_3", navigation: 32 } },
      "/content/page_3/subpage_3_3" => { title: "Page 3.3", parent: { path: "/content/page_3", navigation: 34 } },
    }
  end

  let(:sitemap) do
    {
      "/content/page_1" => { title: "Page 1", navigation: 10 },
      "/content/page_2" => { title: "Page 2", navigation: 30 },
      "/content/page_3" => { title: "Page 3", navigation: 20 },
      "/content/page_4" => { title: "Page 4" },
      "/content/page_5" => { title: "Page 5" },
    }.merge(child_pages)
  end

  subject { described_class.new(sitemap).to_a }
  let(:expected_primary_pages) { %w[/content/page_1 /content/page_3 /content/page_2] }

  let(:actual_primary_pages) { subject.map { |item| item[:path] } }

  specify "includes the pages with a navigation key in the right order" do
    expect(actual_primary_pages).to eql(expected_primary_pages)
  end

  specify "excludes hidden pages" do
    hidden_pages = %w[/content/page_4 /content/page_5]
    expect(actual_primary_pages).to_not include(hidden_pages)
  end

  describe "secondary navigation" do
    let(:expected_child_page_order) { child_pages.map { |_k, v| v.dig(:parent, :navigation) } }
    subject { described_class.new(sitemap).to_a.detect { |item| item[:path] == "/content/page_3" } }

    specify "adds the right number of children to the parent" do
      expect(subject[:children].size).to eql(child_pages.size)
    end

    specify "sets the child paths correctly" do
      child_paths = subject[:children].map { |secondary_nav| secondary_nav[:path] }

      expect(child_paths).to match_array(child_pages.keys)
    end

    specify "the child nodes are in the right order" do
      expected_secondary_nav_order = child_pages.values.map { |child| child.dig(:parent, :path) }.sort
      actual_secondary_nav_order = subject[:children].map { |child| child.dig(:front_matter, :parent, :path) }

      expect(actual_secondary_nav_order).to eql(expected_secondary_nav_order)
    end
  end
end
