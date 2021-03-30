require "page_speed_score"

desc "Google Page Speed Scores"
namespace :page_speed_score do
  desc "Fetch scores for all pages"
  task :fetch_all, [:sitemap_url] => :environment do |_, args|
    puts "Fetching page speed scores..."

    sitemap_url = args[:sitemap_url]

    raise ArgumentError, "You must specify a sitemap_url" if sitemap_url.blank?

    page_speed_score = PageSpeedScore.new(sitemap_url)
    page_speed_score.fetch
  end
end
