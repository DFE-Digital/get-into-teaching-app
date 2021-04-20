require "rails_helper"

RSpec.feature "content pages check", type: :feature, content: true do
  include_context "stub types api"

  before do
    # we don't care about the contents of the events pages here, just
    # that they exist.
    allow_any_instance_of(GetIntoTeachingApiClient::TeachingEventsApi)
      .to(receive(:search_teaching_events_grouped_by_type))
      .and_return([])
  end

  let(:document) { Nokogiri.parse(page.body) }
  let(:statuses_deemed_successful) { Rack::Utils::SYMBOL_TO_STATUS_CODE.values_at(:ok, :moved_permanently) }

  PageLister.content_urls.each do |url|
    describe "visiting #{url}" do
      let(:url) { url }
      before { visit(url) }

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
          .each { |href| expect(href).not_to match(%r{https?://(localhost|127\.0\.0\.1|::1)}) }
      end

      scenario "the internal images exist" do
        document
          .css("img")
          .map { |img| img["data-src"] || img["src"] }
          .reject { |src| src.start_with?("http") }
          .uniq
          .each do |src|
            visit(src)
            expect(page).to have_http_status(:success), "invalid image src on #{url} - #{src}"
          end
      end

      scenario "the internal links reference existing pages" do
        document
          .css("a")
          .map { |fragment| fragment["href"] }
          .reject { |href| href.start_with?(Regexp.union("http:", "https:", "tel:", "mailto:")) }
          .reject { |href| href.match?(Regexp.union("privacy-policy", "events", "javascript")) }
          .select { |href| href.start_with?(Regexp.union("/", /\w+/)) }
          .uniq
          .each do |href|
            visit(href)

            expect(page.status_code).to(be_in(statuses_deemed_successful), "#{href} resulted in #{page.status_code}")

            if (fragment = URI.parse(href).fragment)
              expect(page).to(have_css("#" + fragment), "invalid link on #{url} - #{href}, (missing fragment #{fragment})")
            end
          end
      end

      scenario "there are no internal links that contain the site's domain" do
        document
          .css("a")
          .map { |fragment| fragment["href"] }
          .each do |href|
            expect(href).not_to start_with("https://getintoteaching.education.gov.uk")
            expect(href).not_to start_with("http://getintoteaching.education.gov.uk")
          end
      end
    end
  end

  describe "navbar" do
    subject { page }

    before { visit "/" }

    let(:navigation_pages) { Pages::Frontmatter.select(:navigation) }

    scenario "navigable pages appear in desktop navbar" do
      navigation_pages.each do |url, frontmatter|
        page.within "nav .navbar__desktop" do
          is_expected.to have_link frontmatter[:title], href: url
        end
      end
    end

    scenario "navigable pages appear in mobile navbar" do
      navigation_pages.each do |url, frontmatter|
        page.within "nav .navbar__mobile" do
          is_expected.to have_link frontmatter[:title], href: url
        end
      end
    end

    scenario "mobile nav matches desktop nav" do
      document.css("nav .navbar__desktop a").each do |desktop_link|
        page.within "nav .navbar__mobile" do
          is_expected.to have_link desktop_link.text, href: desktop_link["href"]
        end
      end
    end
  end
end
