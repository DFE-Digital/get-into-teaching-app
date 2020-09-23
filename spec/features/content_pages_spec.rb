require "rails_helper"

RSpec.feature "content pages check", type: :feature do
  IGNORE = %w[
    /test
    /guidance_archive
    /index
    /steps-to-become-a-teacher/v2-index
    /privacy-policy
  ].freeze

  class << self
    def files
      Dir["app/views/content/**/*"]
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

  content_urls.each do |url|
    scenario "visiting #{url}" do
      visit url
      expect(page).to have_http_status :success
    end
  end
end
