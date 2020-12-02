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
      let(:successful_responses) { 200..399 }
      let(:document) { Nokogiri.parse(page.body) }

      scenario "checking that #{url} responds with success" do
        expect(page.status_code).to be_in(successful_responses)
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

            expect(page.status_code).to(be_in(successful_responses), %(invalid link on #{url} - #{href}))

            if (fragment = URI.parse(href).fragment)
              expect(page).to(have_css("#" + fragment), %(invalid link on #{url} - #{href}, (missing fragment #{fragment})))
            end
          end
      end
    end
  end
end
