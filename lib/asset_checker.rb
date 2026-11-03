require "nokogiri"
require "uri"

# Fetches the home page and verifies that the stylesheets and scripts it
# references can be fetched. Returns the URLs that could not be reached; a page
# that references no assets at all is also reported as a failure.
class AssetChecker
  attr_reader :root_url

  def initialize(root_url)
    @root_url = root_url
  end

  def run
    urls = asset_urls(Faraday.get(root_url).body)
    return [root_url] if urls.empty?

    urls.reject { |url| reachable?(url) }
  end

  def reachable?(url)
    Faraday.get(url).status != 404
  rescue Faraday::Error
    false
  end

private

  def asset_urls(html)
    doc = Nokogiri::HTML(html)
    sources = doc.css("script[src]").map { |node| node["src"] } + doc.css("link[rel~=stylesheet][href]").map { |node| node["href"] }

    sources.filter_map { |source| absolute_url(source) }.uniq
  end

  def absolute_url(source)
    url = URI.join("#{root_url}/", source)
    url.to_s if url.is_a?(URI::HTTP) && (URI.parse(source).host.nil? || trusted_host?(source))
  rescue URI::InvalidURIError
    nil
  end

  def trusted_host?(source)
    host = URI.parse(source).host
    [URI.parse(root_url).host, assets_host].compact.include?(host)
  end

  def assets_host
    URI.parse(ENV["APP_ASSETS_URL"]).host unless ENV["APP_ASSETS_URL"].to_s.empty?
  end
end
