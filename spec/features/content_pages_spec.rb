require "rails_helper"

RSpec.feature "content pages check", type: :feature, content: true do
  IGNORE = %w[
    /test
    /guidance_archive
    /index
    /steps-to-become-a-teacher/v2-index
    /privacy-policy
  ].freeze

  class << self
    def files
      Dir["app/views/content/**/[^_]*.md"]
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
    describe "visiting #{url}" do
      let(:url) { url }
      before { visit(url) }
      let(:document) { Nokogiri.parse(page.body) }

      scenario "checking that #{url} responds with success" do
        expect(page).to have_http_status :success
      end

      scenario "the anchor links reference existing IDs" do
        document
          .css("a")
          .map { |fragment| fragment["href"] }
          .select { |href| href.start_with?("#") }
          .reject { |href| href == "#" }
          .each do |href|
            expect(page).to have_css(href)
          end
      end

      scenario "there are no localhost links" do
        document
          .css("a")
          .map { |fragment| fragment["href"] }
          .each { |href| expect(href).not_to match(%r{https?://(localhost|127\.0\.0\.1)}) }
      end

      scenario "the internal links reference existing pages" do
        document
          .css("a")
          .map { |fragment| fragment["href"] }
          .reject { |href| href.start_with?(Regexp.union("http", "tel", "mailto")) }
          .reject { |href| href.match?(Regexp.union("privacy-policy", "events", "javascript")) }
          .select { |href| href.start_with?(Regexp.union("/", /\w+/)) }
          .uniq
          .each do |href|
            visit(href)

            expect(page).to(have_http_status(:success), %(invalid link on #{url} - #{href}))

            if (fragment = URI.parse(href).fragment)
              expect(page).to(have_css("#" + fragment), %(invalid link on #{url} - #{href}, (missing fragment #{fragment})))
            end
          end
      end
    end
  end
end
