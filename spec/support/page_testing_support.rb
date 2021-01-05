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
