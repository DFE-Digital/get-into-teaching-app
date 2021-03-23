require "rails_helper"

RSpec.feature "external links check", :onschedule do
  describe "all pages" do
    it "will have no broken links" do
      results = {}
      faraday = Faraday.new do |f|
        f.request :retry, max: 2
        f.use FaradayMiddleware::FollowRedirects
      end

      PageLister.content_urls.each do |current_page|
        puts "\nCHECKING #{current_page}"
        visit(current_page)
        document = Nokogiri.parse(page.body)
        links = document
                  .css("a")
                  .pluck("href")
                  .select { |href| href.starts_with? %r{https?://} }

        WebMock.enable_net_connect!

        links.each do |external_link|
          if results.key? external_link
            puts "-> [CACHED] #{external_link}"
            # page already checked so just adding to list of pages with broken link
            results[external_link][:pages] << current_page
            next
          else
            puts "-> #{external_link}"
          end

          begin
            faraday_response = faraday.get(external_link)

            results[external_link] = {
              status: faraday_response.status,
              pages: [current_page],
            }
          rescue Faraday::Error
            results[external_link] = {
              status: nil,
              pages: [current_page],
            }
          end
        end

        WebMock.disable_net_connect!
      end

      failures = results.reject do |_page, response|
        (200..299).include? response[:status]
      end

      # comparing to hash instead of checking .empty? so the failures dump
      # the difference in the hashes
      expect(failures).to eql({})
    end
  end
end
