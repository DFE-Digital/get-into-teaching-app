require "rails_helper"

RSpec.feature "link checks", :onschedule do
  describe "internal links" do
    let(:production_url) { "https://getintoteaching.education.gov.uk" }

    specify "all linked-to pages exist" do
      results = LinkChecker::Results.new

      PageLister.content_urls.map { |path| production_url + path }.each do |current_page|
        WebMock.enable_net_connect!
        visit(current_page)
        checker = LinkChecker.new(current_page, page.body, adjust_packs_path: %w[packs-test packs])
        checker.check_links(production_url, results)
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
