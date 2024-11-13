require "yaml"
require "action_dispatch/testing/integration"
require "digest/sha1"

LASTMOD_FILE_PATH = Rails.root.join("config/lastmod.yml")

desc "Recalculates lastmod date for each of the content pages"
task lastmod: :environment do
  yaml    = YAML.load(File.open(LASTMOD_FILE_PATH))
  logs    = []
  app     = ActionDispatch::Integration::Session.new(Rails.application)
  headers = { "Host" => "localhost:3000" }

  published_pages.each do |page|
    path = page.first
    response = request_path(path, app, headers)
    document = Nokogiri::HTML(response.body).css("body") # Only hash body content as head is liable to change frequently
    document = sanitize_document(document)
    hash = hash_document(document)

    # If content hash has changed
    next unless hash != yaml[path]["hash"]

    logs << "#{path} has changed"

    yaml[path] = {
      "date" => Time.current.to_s,
      "hash" => hash,
    }
  end

  File.open(LASTMOD_FILE_PATH, "w") { |f| YAML.dump(yaml, f) }
  puts logs.join("\n") if logs.any?
end

def published_pages
  events = GetIntoTeachingApiClient::TeachingEventsApi.new.search_teaching_events(
    start_after: Time.zone.now,
    quantity: 100,
    type_ids: [Crm::EventType.get_into_teaching_event_id, Crm::EventType.online_event_id],
  )
  content_pages   = ::Pages::Frontmatter.list.reject { |_path, fm| fm[:draft] }
  event_pages     = events.map { |e| Rails.application.routes.url_helpers.event_path(e.readable_id) }.index_with({})
  content_pages.merge(event_pages)
end

def request_path(path, app, headers)
  app.get(path, headers: headers)
  redirected_path = app.response.headers["Location"]
  app.get(redirected_path, headers: headers) if redirected_path # Follow if redirected
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
