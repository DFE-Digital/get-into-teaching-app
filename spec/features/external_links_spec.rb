require "rails_helper"

RSpec.feature "external links check", :onschedule do
  describe "all pages" do
    it "will have no broken links" do
      results = LinkChecker::Results.new

      PageLister.content_urls.each do |current_page|
        visit(current_page)
        checker = LinkChecker.new(current_page, page.body)

        WebMock.enable_net_connect!
        checker.check_links(results)
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
