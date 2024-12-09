require "action_dispatch/testing/integration"
require "digest/sha1"

class PageModificationTracker
  MANUAL_PAGES = {
    "/events/about-get-into-teaching-events" => {},
    "/events" => {},
    "/mailinglist/signup/name" => {},
  }.freeze

  attr_reader :app, :headers

  def initialize(host: "localhost:3000", selector: "body")
    @app = ActionDispatch::Integration::Session.new(Rails.application)
    @headers = { "Host" => host }
    @selector = selector

    if ENV["BASIC_AUTH"] == "1"
      authorization = ActionController::HttpAuthentication::Basic.encode_credentials(ENV["HTTPAUTH_USERNAME"], ENV["HTTPAUTH_PASSWORD"])
      @headers = @headers.merge({ "Authorization" => authorization })
    end
  end

  def track_page_modifications
    published_pages.each_key do |path|
      response = request_path(path, @app, @headers)

      # Handle nil or empty response
      next if response.nil? || response.body.nil? || response.body.empty?

      document = Nokogiri::HTML(response.body).css(@selector) # Only hash body content as head is liable to change frequently
      sanitized_document = sanitize_document(document)
      content_hash = hash_document(sanitized_document)
      page_mod = PageModification.find_or_initialize_by(path: path)

      if page_mod.new_record? || page_mod.content_hash != content_hash
        page_mod.update!(content_hash: content_hash)
      end
    rescue StandardError => e
      Sentry.configure_scope do |scope|
        scope.set_context("page_modification", { path: path })
      end
      Sentry.capture_exception(e)
      next
    end
  end

private

  def published_pages
    events = GetIntoTeachingApiClient::TeachingEventsApi.new.search_teaching_events(
      start_after: Time.zone.now,
      quantity: 100,
      type_ids: [Crm::EventType.get_into_teaching_event_id, Crm::EventType.online_event_id],
    )
    content_pages = ::Pages::Frontmatter.list.reject { |_path, fm| fm[:draft] }
    event_pages = events.map { |e| Rails.application.routes.url_helpers.event_path(e.readable_id) }.index_with({})
    content_pages.merge(**event_pages, **MANUAL_PAGES)
  end

  def request_path(path, app, headers)
    app.get(path, headers: headers)
    redirected_path = app.response&.headers&.[]("Location")
    app.get(redirected_path, headers: headers) if redirected_path
    app.response
  end

  def sanitize_document(document)
    auth_token_input = document.at_css("form input[name='authenticity_token']")
    auth_token_input["value"] = "" if auth_token_input
    document
  end

  def hash_document(document)
    Digest::SHA1.hexdigest(document.to_s)
  end
end
