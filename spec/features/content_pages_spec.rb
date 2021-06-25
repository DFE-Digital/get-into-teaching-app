require "rails_helper"

class StoredPage
  attr_accessor :path, :status_code, :body

  def initialize(path, status_code, body)
    @path        = path
    @status_code = status_code
    @body        = body
  end
end

RSpec.feature "content pages check", type: :feature, content: true do
  include_context "stub types api"

  let(:other_paths) { %w[/ /search /tta-service /mailinglist/signup /mailinglist/signup/name /cookies /cookie_preference] }
  let(:ignored_path_patterns) { [%r{/assets/documents/}, %r{/event-categories}] }

  before do
    # we don't care about the contents of the events pages here, just
    # that they exist.
    allow_any_instance_of(GetIntoTeachingApiClient::TeachingEventsApi)
      .to(receive(:search_teaching_events_grouped_by_type))
      .and_return([])
  end

  # rubocop:disable RSpec/BeforeAfterAll
  before(:all) do
    statuses_deemed_successful = Rack::Utils::SYMBOL_TO_STATUS_CODE.values_at(:ok, :moved_permanently)

    @stored_pages = PageLister.content_urls.map do |path|
      visit(path)

      fail unless page.status_code.in?(statuses_deemed_successful)

      StoredPage.new(path, page.status_code, Nokogiri.parse(page.body))
    end

    @stored_pages_by_path = @stored_pages.index_by(&:path)
  end

  after(:all) { @stored_pages = nil }
  # rubocop:enable RSpec/BeforeAfterAll

  describe "content checks" do
    scenario "responds with success" do
      expect(@stored_pages.map(&:status_code)).to all(be(200))
    end

    scenario "the anchor links reference existing IDs" do
      @stored_pages.each do |sp|
        sp.body
          .css("a")
          .map { |fragment| fragment["href"] }
          .select { |href| href.start_with?("#") }
          .reject { |href| href == "#" }
          .each do |href|
            expect(sp.body).to have_css(href)
          end
      end
    end

    scenario "there are no localhost links" do
      @stored_pages.each do |sp|
        sp.body
          .css("a")
          .map { |fragment| fragment["href"] }
          .each { |href| expect(href).not_to match(%r{https?://(localhost|127\.0\.0\.1|::1)}) }
      end
    end

    scenario "the internal images exist" do
      images = []
      @stored_pages.each do |sp|
        sp.body
          .css("img")
          .map { |img| img["data-src"] || img["src"] }
          .reject { |src| src.start_with?("http") }
          .uniq
          .each do |src|
            next unless src.in?(images)

            visit(src)
            expect(page).to have_http_status(:success), "invalid image src on #{sp.path} - #{src}"
            images.push(src)
          end
      end
    end

    scenario "the internal links reference existing pages" do
      paths = other_paths.concat(@stored_pages.map(&:path))
      @stored_pages.each do |sp|
        sp.body
          .css("a")
          .map { |fragment| fragment["href"] }
          .reject { |href| href.start_with?(Regexp.union("http:", "https:", "tel:", "mailto:")) }
          .reject { |href| href.match?("media/") }
          .reject { |href| href.match?(Regexp.union("privacy-policy", "events", "javascript")) }
          .select { |href| href.start_with?(Regexp.union("/", /\w+/)) }
          .uniq
          .each do |href|
            next if ignored_path_patterns.any? { |p| p.match?(href) }

            uri = URI.parse(href)

            expect(paths).to include(uri.path)

            if (fragment = uri.fragment)
              expect(@stored_pages_by_path[uri.path].body).to(have_css("#" + fragment), "invalid link on #{sp.path} - #{href}, (missing fragment #{fragment})")
            end
          end
      end
    end

    scenario "there are no internal links that contain the site's domain" do
      @stored_pages.each do |sp|
        sp.body
          .css("a")
          .map { |fragment| fragment["href"] }
          .each do |href|
          expect(href).not_to start_with("https://getintoteaching.education.gov.uk")
          expect(href).not_to start_with("http://getintoteaching.education.gov.uk")
        end
      end
    end
  end

  describe "navigation" do
    subject { page }

    before { visit "/" }
    let(:document) { Nokogiri.parse(page.body) }

    let(:navigation_pages) { Pages::Frontmatter.select(:navigation) }

    scenario "navigable pages appear in desktop navbar" do
      # skip home as we've just navigated to '/'
      navigation_pages.reject { |k, _v| k == "/home" }.each do |url, frontmatter|
        page.within "nav ol" do
          is_expected.to have_link frontmatter[:title], href: url
        end
      end
    end
  end
end
