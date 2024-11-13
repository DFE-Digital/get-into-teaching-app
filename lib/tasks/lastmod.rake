require 'yaml'
require "action_dispatch/testing/integration"
require "digest/sha1"

desc "Recalculates lastmod date for each of the content pages"

task :lastmod => :environment do
  LASTMOD_FILE_PATH = Rails.root.join("config/lastmod.yml")

  events = GetIntoTeachingApiClient::TeachingEventsApi.new.search_teaching_events(
    start_after: Time.zone.now,
    quantity: 100,
    type_ids: [Crm::EventType.get_into_teaching_event_id, Crm::EventType.online_event_id],
  )    
  content_pages   = ::Pages::Frontmatter.list.reject { |_path, fm| fm[:draft] }
  event_pages     = events.map { |e| Rails.application.routes.url_helpers.event_path(e.readable_id) }.index_with({})
  published_pages = content_pages.merge(event_pages)

  yaml = YAML.load(File.open(LASTMOD_FILE_PATH))
  logs = []

  published_pages.each do |page|
    path    = page.first
    headers = { "Host" => "localhost:3000" }
    app     = ActionDispatch::Integration::Session.new(Rails.application)

    app.get(path, headers: headers)
    redirected_path = app.response.headers["Location"]

    body = if redirected_path 
             app.get(redirected_path, headers: headers)
             app.response.body
           else
             app.response.body
           end

    document = Nokogiri::HTML(body).css("body") # Only hash body content as head is liable to change frequently

    # Strip authenticity token as this changes per request
    auth_token_input = document.at_css("form input[name='authenticity_token']")
    auth_token_input['value'] = "" if auth_token_input

    # Hash content
    hash = Digest::SHA1.hexdigest(document.to_s)

    # If content hash has changed
    if hash != yaml[path]["hash"]
      logs << "#{path} has changed"

      yaml[path] = { 
        "date" => DateTime.current.to_s,
        "hash" => hash 
      }
    end
  end

  # Update yaml file
  File.open(LASTMOD_FILE_PATH, 'w') { |f| YAML.dump(yaml, f) }

  puts logs.join("\n")
end
