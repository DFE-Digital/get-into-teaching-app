require "rails_helper"

RSpec.describe SitemapController, type: :request do
  subject { Nokogiri::XML(response.body) }

  let(:content_pages) do
    {
      "/ways-to-train" => {
        name: "Ways to train",
        priority: 0.8,
        date: "2020-11-11",
      },
      "/salaries-and-benfits" => {
        name: "Salaries and benefits",
        priority: 0.7,
      },
      "/my-story-into-teaching/what-a-great-story" => {
        name: "What a great story",
        priority: 0.7,
        date: "2020-10-10",
      },
    }
  end

  before do
    allow(Pages::Frontmatter).to receive(:list) { content_pages }
    get("/sitemap.xml")
  end

  describe "#show" do
    let(:sitemap_namespace) { "http://www.sitemaps.org/schemas/sitemap/0.9" }

    specify "the document should have the correct namespace" do
      expect(subject.at_xpath("/xmlns:urlset").namespace.href).to eql(sitemap_namespace)
    end

    describe "content_pages" do
      let(:expected) { SitemapController::OTHER_PATHS.count + content_pages.count }
      let(:paths) { content_pages.keys.concat(SitemapController::OTHER_PATHS) }

      specify "should have the right number of content_pages" do
        expect(expected).to eql(subject.xpath("/xmlns:urlset/xmlns:url").size)
      end

      specify "the content_pages should have the correct paths" do
        expect(
          subject
            .xpath("xmlns:urlset/xmlns:url/xmlns:loc")
            .map { |node| URI(node.text).path },
        ).to match_array(paths)
      end
    end

    describe "priority" do
      specify "priority should be assinged from frontmatter" do
        content_pages.each do |path, data|
          importance = subject.at_xpath(
            %(/xmlns:urlset/xmlns:url[xmlns:loc = 'http://www.example.com#{path}']/xmlns:priority),
          ).text

          expect(importance).to eql(data[:priority].to_s)
        end
      end
    end

    describe "lastmod" do
      specify "last modified date should be assinged from frontmatter" do
        content_pages.each do |path, data|
          last_modified = subject.at_xpath(
            %(/xmlns:urlset/xmlns:url[xmlns:loc = 'http://www.example.com#{path}']/xmlns:lastmod),
          ).text

          expect(last_modified).to eql((data[:date] || SitemapController::DEFAULT_LASTMOD).to_s)
        end
      end
    end

    context "when a page is set to draft" do
      let(:content_pages) do
        {
          "/draft" => {
            name: "Draft page",
            draft: true,
          },
          "/published" => {
            name: "Published page",
            draft: false,
          },
        }
      end

      specify "draft pages aren't included in the sitemap" do
        expect(subject).not_to match(/draft/)
      end

      specify "published pages are included in the sitemap" do
        expect(subject).to match(/published/)
      end
    end
  end
end
