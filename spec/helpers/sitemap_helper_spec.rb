require "rails_helper"

describe SitemapHelper, type: :helper do
  describe "#navigation_resources" do
    let(:sitemap) do
      {
        markdown_content: [
          { title: "Page 1", front_matter: { navigation: 10 } },
          { title: "Page 2", front_matter: { navigation: 30 } },
          { title: "Page 3", front_matter: { navigation: 20 } },
        ],
      }
    end

    subject { helper.navigation_resources(sitemap) }

    it { expect(subject.map { |r| r[:title] }).to eq(["Page 1", "Page 3", "Page 2"]) }
  end
end
