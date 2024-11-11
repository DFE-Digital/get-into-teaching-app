require 'yaml'
require 'net/http'
include Rails.application.routes.url_helpers
require "action_dispatch/testing/integration"
require "digest/sha1"

desc "Recalculates lastmod date for each of the content pages"

task :lastmod => :environment do
  LASTMOD_FILE_PATH = Rails.root.join("config/lastmod.yml")

  # 1. Get all the content pages to monitor

  events = GetIntoTeachingApiClient::TeachingEventsApi.new.search_teaching_events(
    start_after: Time.zone.now,
    quantity: 100,
    type_ids: [Crm::EventType.get_into_teaching_event_id, Crm::EventType.online_event_id],
  )    
    
  content_pages = ::Pages::Frontmatter.list.reject { |_path, fm| fm[:draft] }
  event_pages = events.map { |e| event_path(e.readable_id) }.index_with({})
  published_pages = content_pages.merge(event_pages)

  ## 2. For each page we want to monitor, make a request

  # Making a request with a single page so far: "/"
  # path = published_pages.keys.first

  app = ActionDispatch::Integration::Session.new(Rails.application)
  app.get("/", headers: { "Host" => "localhost:3000" })

  ## Follow the redirect if there is one
  # redirected_path = app.response.headers["Location"]
  # body = if redirected_path 
  #          app.get(redirected_path, headers: { "Host" => "localhost:3000" })
  #          app.response.body
  #        else
  #          app.response.body
  #        end

  # Write the response to a html file for now...
  File.write(Rails.root.join("LASTMOD.html"), app.response.body)

  ## 3. Extract the body and hash it
  # document = Nokogiri::HTML(body).css("body")
  # hash      = Digest::SHA1.hexdigest(document.to_s)

  # yaml = {
  #   path => { 
  #     "id" => 1, 
  #     "html" => body, 
  #     "body" => document,
  #     "date" => Time.current, 
  #     "hash" => hash 
  #   }
  # }
  #
  ## 4. Write paths to a yml file / Compare with previous hashes / determine lastmod event
  # File.write(LASTMOD_FILE_PATH, yaml.to_yaml)
end
