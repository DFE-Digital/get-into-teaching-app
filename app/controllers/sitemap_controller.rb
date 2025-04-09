class SitemapController < ApplicationController
  DEFAULT_LASTMOD = "2021-03-01".freeze
  FUTURE_EVENTS_LIMIT = 100

  ALIASES = {
    "/home" => "/",
  }.freeze

  # http://en.wikipedia.org/wiki/URL_normalization
  # Ensure any index route (collection) has a trailing slash (representing the semantics of a directory).
  # This will keep it consistent with how canonical-rails behaves and ensure search engines are happy.
  OTHER_PATHS = {
    "/events" => { title: "Events" },
    "/events/about-get-into-teaching-events" => { title: "About Get Into Teaching Events" },
    "/mailinglist/signup/name" => { title: "Mailing List" },
    "/routes-into-teaching" => { title: "Routes Into Teaching" },
  }.freeze

  before_action :set_page_title
  before_action :set_breadcrumb

  layout "minimal"

  def show
    @sitemap_data ||= all_sitemap_pages.sort_by { |_path, metadata| metadata[:title] }
    @a_z_sitemap_data ||= @sitemap_data.group_by { |_path, metadata| metadata[:title][0] }

    respond_to do |format|
      format.xml { render xml: build.to_xml }
      format.html { render :show }
    end
  end

private

  def build
    Nokogiri::XML::Builder.new(encoding: "UTF-8") do |xml|
      xml.urlset(xmlns: "http://www.sitemaps.org/schemas/sitemap/0.9") do
        all_sitemap_pages.each do |path, metadata|
          xml.url do
            xml.loc(request.base_url + page_location(path))
            xml.lastmod(lastmod_date(path, metadata))
            xml.priority(metadata.fetch(:priority)) if metadata.key?(:priority)
          end
        end
      end
    end
  end

  def all_sitemap_pages
    published_pages.merge(OTHER_PATHS).reject { |_path, metadata| metadata[:noindex] }
  end

  def lastmod_date(path, metadata = nil)
    metadata&.dig(:date) || PageModification.find_by(path: path)&.updated_at&.strftime("%Y-%m-%d") || DEFAULT_LASTMOD
  end

  def published_pages
    content_pages.merge(event_pages)
  end

  def event_pages
    events.to_h do |event|
      [event_path(event.readable_id), { title: event.name }]
    end
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

  def set_page_title
    @page_title = "A to Z index"
  end

  def set_breadcrumb
    breadcrumb @page_title, request.path
  end
end
