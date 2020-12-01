require "rails_helper"

describe SitemapHelper, type: :helper do
  describe "#navigation_resources" do
    let(:sitemap) do
      {
        "/content/page_1": { title: "Page 1", navigation: 10 },
        "/content/page_2": { title: "Page 2", navigation: 30 },
        "/content/page_3": { title: "Page 3", navigation: 20 },
        "/content/page_4": { title: "Page 4" },
      }
    end

    before { allow(Pages::Frontmatter).to receive(:list).and_return(sitemap) }

    subject! { helper.navigation_resources }

    specify "obtains the resources from Pages::Frontmatter" do
      expect(Pages::Frontmatter).to have_received(:list)
    end

    specify "selects the items with a navigation key and order them" do
      expect(subject.map { |r| r.dig(:front_matter, :title) }).to eq(["Page 1", "Page 3", "Page 2"])
    end
  end
end
