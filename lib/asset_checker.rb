class AssetChecker
  attr_reader :root_url

  ASSET_PATTERN = /(\/packs\/(js|css)\/.+\.(js|css))/

  def initialize(root_url)
    @root_url = root_url
  end

  def run
    html = Faraday.get(root_url).body
    html.scan(ASSET_PATTERN)
      .map(&:first)
      .map { |path| root_url + path }
      .reject { |url| reachable?(url) }
  end

  def reachable?(url)
    Faraday.get(url).status != 404
  rescue Faraday::ConnectionFailed
    false
  end
end
