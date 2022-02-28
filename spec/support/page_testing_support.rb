class PageLister
  IGNORE = %w[
    /test
    /guidance_archive
    /index
    /steps-to-become-a-teacher/v2-index
    /privacy-policy
  ].freeze

  class << self
    def md_files
      Dir["app/views/content/**/[^_]*.md"]
    end

    def html_files
      Dir["app/views/content/**/[^_]*.html.erb"]
    end

    def files
      html_files + md_files
    end

    def remove_folders(filename)
      filename.gsub "app/views/content", ""
    end

    def remove_extension(filename)
      filename.gsub %r{(\.[a-zA-Z0-9]+)+\z}, ""
    end

    def content_urls
      files.map(&method(:remove_folders)).map(&method(:remove_extension)) - IGNORE
    end
  end
end

class LinkChecker
  class Results < Hash; end

  IGNORE_PREFIX = %r{^/welcome}.freeze
  Result = Struct.new(:status, :pages)

  attr_reader :page, :document

  def initialize(page, body, adjust_packs_path: [])
    @page = page
    @document = Nokogiri.parse(body)

    # we need to adjust the packs URL when testing against prod
    @adjust_packs_path = adjust_packs_path
  end

  def links
    document.css("a").pluck("href")
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
