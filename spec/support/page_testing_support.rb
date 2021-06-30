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
  IGNORE = %w[
    127.0.0.1
    localhost
    ::1
    www.linkedin.com
    linkedin.com
    www.exetermathematicsschool.ac.uk
    www.ringwood.hants.sch.uk
    www.sjctsa.co.uk
  ].freeze

  attr_reader :page, :document

  class Results < Hash; end
  Result = Struct.new(:status, :pages)

  def initialize(page, body)
    @page = page
    @document = Nokogiri.parse(body)
  end

  def check_links(results = Results.new)
    external_links.each do |link|
      next if ignored?(link)

      results[link] ||= Result.new(check(link), [])
      results[link].pages << page
    end

    results
  end

private

  def links
    document.css("a").pluck("href")
  end

  def external_links
    links.select { |href| href.starts_with? %r{https?://} }
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

  def fallback_check(link)
    # Not all websites respond to a HEAD request,
    # so we do a GET request as a fallback check.
    faraday(link).get.status
  rescue ::Faraday::Error
    nil
  end

  def ignored?(link)
    IGNORE.any? do |ignore|
      link.starts_with? %r{https?://#{ignore}/}
    end
  end
end
