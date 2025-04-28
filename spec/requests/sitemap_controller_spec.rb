require "rails_helper"

RSpec.describe SitemapController, type: :request do
  let(:events) { build_list(:event_api, 3) }

  let(:content_pages) do
    {
      "/train-to-be-a-teacher" => {
        title: "Train to be a teacher",
        priority: 0.8,
        date: "2020-11-11",
      },
      "/salaries-and-benefits" => {
        title: "Salaries and benefits",
        priority: 0.7,
      },
      "/my-story-into-teaching/what-a-great-story" => {
        title: "What a great story",
        priority: 0.7,
        date: "2020-10-10",
      },
      "/test/a" => {
        title: "A/B Test",
        noindex: true,
      },
      "/draft" => {
        title: "Draft page",
        draft: true,
      },
    }
  end

  let(:other_paths) do
    {
      "/events" => { title: "Events" },
      "/events/about-get-into-teaching-events" => { title: "About Get Into Teaching Events" },
    }
  end

  let(:valid_pages_with_data) do
    content_pages.merge(other_paths).reject do |_path, data|
      data[:noindex] || data[:draft]
    end
  end

  before do
    freeze_time
    allow(Pages::Frontmatter).to receive(:list).and_return(content_pages)
    allow_any_instance_of(GetIntoTeachingApiClient::TeachingEventsApi).to \
      receive(:search_teaching_events).with(
        start_after: Time.zone.now,
        quantity: 100,
        type_ids: [Crm::EventType.get_into_teaching_event_id, Crm::EventType.online_event_id],
      ).and_return(events)
    stub_const("SitemapController::OTHER_PATHS", other_paths)
  end

  describe "GET /sitemap" do
    let(:doc) { Nokogiri::HTML(response.body) }
    let(:links) { doc.css("a[href^='/']").map { |a| a["href"] } }

    before { get "/sitemap" }

    it "renders the HTML sitemap" do
      expect(response).to be_successful
      expect(response.content_type).to include("text/html")
    end

    it "renders the correct pages" do
      expect(links).to include("/train-to-be-a-teacher", "/salaries-and-benefits", "/my-story-into-teaching/what-a-great-story")

      events.each do |event|
        expect(links).to include(event_path(event.readable_id))
      end

      other_paths.each_key do |path|
        expect(links).to include(path)
      end
    end

    it "does not include noindex pages" do
      expect(links).not_to include("/test/a")
    end

    it "does not include draft pages" do
      expect(links).not_to include("/draft")
    end
  end

  describe "GET /sitemap.xml" do
    let(:doc) { Nokogiri::XML(response.body) }
    let(:sitemap_namespace) { "http://www.sitemaps.org/schemas/sitemap/0.9" }
    let(:locs) { doc.xpath("//xmlns:url/xmlns:loc").map { |node| URI(node.text).path } }

    before { get "/sitemap.xml" }

    it "renders an XML sitemap" do
      expect(response).to be_successful
      expect(response.content_type).to include("application/xml")
    end

    it "has the correct namespace" do
      expect(doc.at_xpath("/xmlns:urlset").namespace.href).to eql(sitemap_namespace)
    end

    it "renders the correct pages" do
      expect(locs).to include("/train-to-be-a-teacher", "/salaries-and-benefits", "/my-story-into-teaching/what-a-great-story")

      events.each do |event|
        expect(locs).to include(event_path(event.readable_id))
      end

      other_paths.each_key do |path|
        expect(locs).to include(path)
      end
    end

    it "does not include noindex pages" do
      expect(locs).not_to include("/test/a")
    end

    it "does not include draft pages" do
      expect(locs).not_to include("/draft")
    end

    it "assigns priority level from frontmatter" do
      valid_pages_with_data.each do |path, data|
        next unless data[:priority]

        priority = doc.at_xpath(
          %(/xmlns:urlset/xmlns:url[xmlns:loc = 'http://www.example.com#{path}']/xmlns:priority),
        ).text

        expect(priority).to eql(data[:priority].to_s)
      end
    end

    it "assigns lastmod date from frontmatter" do
      valid_pages_with_data.each do |path, data|
        next unless data[:lastmod]

        last_modified = subject.at_xpath(
          %(/xmlns:urlset/xmlns:url[xmlns:loc = 'http://www.example.com#{path}']/xmlns:lastmod),
        ).text

        expect(last_modified).to eql((data[:date] || SitemapController::DEFAULT_LASTMOD).to_s)
      end
    end
  end
end
