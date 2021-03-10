require "rails_helper"

RSpec.describe SitemapController do
  subject { Nokogiri::XML(response.body) }

  let(:nodes) do
    {
      "/ways-to-train" => {
        "name" => "Ways to train",
        "priority" => 0.8,
        "date" => "2020-11-11",
      },
      "/salaries-and-benfits" => {
        "name" => "Salaries and benefits",
        "priority" => 0.7,
      },
      "/my-story-into-teaching/what-a-great-story" => {
        "name" => "What a great story",
        "priority" => 0.7,
        "date" => "2020-10-10",
      },
    }
  end

  before { allow(Pages::Frontmatter).to receive(:list) { nodes } }

  before { get("/sitemap.xml") }

  describe "#show" do
    let(:sitemap_namespace) { "http://www.sitemaps.org/schemas/sitemap/0.9" }
    specify "the document should have the correct namespace" do
      expect(subject.at_xpath("/xmlns:urlset").namespace.href).to eql(sitemap_namespace)
    end

    describe "nodes" do
      let(:expected) { SitemapController::OTHER_PATHS.count + nodes.count }
      let(:paths) { nodes.keys.concat(SitemapController::OTHER_PATHS) }

      specify "should have the right number of nodes" do
        expect(expected).to eql(subject.xpath("/xmlns:urlset/xmlns:url").size)
      end

      specify "the nodes should have the correct paths" do
        expect(
          subject
            .xpath("xmlns:urlset/xmlns:url/xmlns:loc")
            .map { |node| URI(node.text).path },
        ).to match_array(paths)
      end
    end

    describe "priority" do
      specify "priority should be assinged from frontmatter" do
        nodes.each do |path, data|
          importance = subject.at_xpath(
            %(/xmlns:urlset/xmlns:url[xmlns:loc = 'http://www.example.com#{path}']/xmlns:priority),
          ).text

          expect(importance).to eql(data["priority"].to_s)
        end
      end
    end

    describe "lastmod" do
      specify "last modified date should be assinged from frontmatter" do
        nodes.each do |path, data|
          last_modified = subject.at_xpath(
            %(/xmlns:urlset/xmlns:url[xmlns:loc = 'http://www.example.com#{path}']/xmlns:lastmod),
          ).text

          expect(last_modified).to eql((data["date"] || SitemapController::DEFAULT_LASTMOD).to_s)
        end
      end
    end
  end
end
