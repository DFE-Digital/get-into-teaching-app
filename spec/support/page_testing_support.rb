class PageLister
  class << self
    def all_md_files
      Dir["app/views/**/*.md"]
    end

    def all_erb_files
      Dir["app/views/**/*.erb"]
    end

    def all_locale_files
      Dir["config/locales/**/*.{yml,yaml}"]
    end

    def all_ruby_files
      Dir["app/**/*.rb"]
    end

    def content_md_files_excl_partials
      Dir["app/views/content/**/[^_]*.md"]
    end

    def content_html_files_excl_partials
      Dir["app/views/content/**/[^_]*.html.erb"]
    end

    def content_files_excl_partials
      content_html_files_excl_partials + content_md_files_excl_partials
    end

    def remove_folders(filename)
      filename.gsub "app/views/content", ""
    end

    def remove_extension(filename)
      filename.gsub %r{(\.[a-zA-Z0-9]+)+\z}, ""
    end

    def content_urls
      content_files_excl_partials.map(&method(:remove_folders)).map(&method(:remove_extension))
    end
  end
end

class LinkChecker
  class Results < Hash; end

  IGNORE_PREFIX = %r{^/welcome}
  Result = Struct.new(:status, :pages)

  attr_reader :page, :document

  def initialize(page, body, adjust_packs_path: [])
    @page = page
    @document = Nokogiri.parse(body)

    # we need to adjust the packs URL when testing against prod
    @adjust_packs_path = adjust_packs_path
  end

  def links
    document.css("a").pluck("href").map { |link| link.gsub("\\", "") }
  end

  def faraday(link)
    ::Faraday.new(link) do |f|
      f.request :retry, max: 2
      f.use ::FaradayMiddleware::FollowRedirects
    end
  end

  def check(link)
    status = faraday(link).head.status
    return status if (200..299).include?(status)

    fallback_check(link)
  rescue ::Faraday::Error
    fallback_check(link)
  end

  def check_links(host, results = Results.new)
    internal_links.each do |link|
      next if link =~ IGNORE_PREFIX

      results[link] ||= Result.new(check(build_url(host, link)), [])
      results[link].pages << page
    end

    results
  end

  def fallback_check(link)
    # Not all websites respond to a HEAD request,
    # so we do a GET request as a fallback check.
    faraday(link).get.status
  rescue ::Faraday::Error
    nil
  end

  def internal_links
    links.select { |href| href.starts_with?("/") }
  end

  def build_url(host, link)
    url = host + link

    return url if @adjust_packs_path.blank?

    url.gsub(*@adjust_packs_path)
  end
end

class MonetaryChecker
  MONEY_REGEXP = /(([$£€]|&dollar;|&pound;|&euro;|&#36;|&#163;|&#8364;)\d+(,\d{3})*([.,]\d{1,2}p?)?k?)/m
end
