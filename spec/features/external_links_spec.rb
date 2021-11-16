require "rails_helper"

RSpec.feature "link checks", :onschedule do
  describe "all pages (external)" do
    PageLister.content_urls.each do |current_page|
      context "page: #{current_page}" do
        before { WebMock.enable_net_connect! }

        after { WebMock.disable_net_connect! }

        specify "returns a 200..299 status" do
          visit(current_page)
          results = LinkChecker::Results.new
          LinkChecker::External.new(current_page, page.body).check_links(results)

          failures = results.reject do |_page, response|
            response[:status].in?(200..299)
          end

          expect(failures).to eql({})
        end
      end
    end
  end

  describe "all pages (internal)" do
    let(:production_url) { "https://getintoteaching.education.gov.uk" }

    PageLister.content_urls.each do |current_page|
      context "page: #{current_page}" do
        before { WebMock.enable_net_connect! }

        after { WebMock.disable_net_connect! }

        specify "returns a 200..299 status" do
          visit(current_page)
          results = LinkChecker::Results.new

          LinkChecker::Internal
            .new(current_page, page.body, adjust_packs_path: %w[packs-test packs])
            .check_links(production_url, results)

          failures = results.reject do |_page, response|
            response[:status].in?(200..299)
          end

          expect(failures).to eql({})
        end
      end
    end
  end
end
