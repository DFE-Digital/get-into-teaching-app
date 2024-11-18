class SitemapController < ApplicationController
  DEFAULT_LASTMOD = "2021-03-01".freeze
  FUTURE_EVENTS_LIMIT = 100

  ALIASES = {
    "/home" => "/",
  }.freeze

  # http://en.wikipedia.org/wiki/URL_normalization
  # Ensure any index route (collection) has a trailing slash (representing the semantics of a directory).
  # This will keep it consistent with how canonical-rails behaves and ensure search engines are happy.
  OTHER_PATHS = %w[
    /events
    /blog
    /events/about-get-into-teaching-events
    /mailinglist/signup/name
  ].freeze

  def show
    render xml: build.to_xml
  end

private

  def build
    Nokogiri::XML::Builder.new(encoding: "UTF-8") do |xml|
      xml.urlset(xmlns: "http://www.sitemaps.org/schemas/sitemap/0.9") do
        published_pages.each do |path, metadata|
          next if metadata[:noindex]

          xml.url do
            xml.loc(request.base_url + page_location(path))
            xml.lastmod(lastmod_date(path, metadata))
            xml.priority(metadata.fetch(:priority)) if metadata.key?(:priority)
          end
        end

        OTHER_PATHS.each do |events_path|
          xml.url do
            xml.loc(request.base_url + events_path)
            xml.lastmod(lastmod_date(events_path))
          end
        end
      end
    end
  end

  def lastmod_date(path, metadata = nil)
    page_mod = PageModification.find_by(path: path)
    lastmod_date = page_mod&.updated_at&.strftime("%Y-%m-%d")

    metadata&.dig(:date) || lastmod_date || DEFAULT_LASTMOD
  end

  def published_pages
    content_pages.merge(event_pages)
  end

  def event_pages
    events.map { |e| event_path(e.readable_id) }.index_with({})
  end

  def events
    GetIntoTeachingApiClient::TeachingEventsApi.new.search_teaching_events(
      start_after: Time.zone.now,
      quantity: FUTURE_EVENTS_LIMIT,
      type_ids: [Crm::EventType.get_into_teaching_event_id, Crm::EventType.online_event_id],
    )
  end

  def content_pages
    ::Pages::Frontmatter.list.reject { |_path, fm| fm[:draft] }
  end

  def page_location(path)
    ALIASES.fetch(path) { path }
  end
end
