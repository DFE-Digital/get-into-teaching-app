require "google/apis/pagespeedonline_v5"
require "prometheus/client/push"

class PageSpeedScore
  attr_reader :sitemap_url

  BATCH_SIZE = 10
  STRATEGIES = %w[mobile desktop].freeze
  CATEGORIES = %w[performance accessibility seo].freeze
  FIELDS = "lighthouse_result(categories(seo/score,performance/score,accessibility/score))".freeze

  def initialize(sitemap_url)
    @sitemap_url = sitemap_url
  end

  def fetch
    urls.product(STRATEGIES).each_slice(BATCH_SIZE) do |requests|
      threads = requests.map do |url, strategy|
        Thread.new do
          options = default_options.merge!({ strategy: strategy })
          result = service.runpagespeed_pagespeedapi(url, options)
          record_metrics(result, url, strategy)
        end
      end

      threads.each(&:join)
    end

    Prometheus::Client::Push.new("page_speed_score_job").add(prometheus)
  end

private

  def record_metrics(result, url, strategy)
    categories = result.lighthouse_result.categories
    path = URI(url).path

    CATEGORIES.each do |category|
      metric = prometheus.get("app_page_speed_score_#{category}".to_sym)
      metric.set(categories.send(category).score, labels: { strategy: strategy, path: path })
    end
  end

  def default_options
    {
      category: CATEGORIES,
      fields: FIELDS,
    }
  end

  def urls
    sitemap_xml = Nokogiri::XML(URI.open(sitemap_url))
    sitemap_xml.css("loc").map(&:text)
  end

  def service
    @service ||= Google::Apis::PagespeedonlineV5::PagespeedInsightsService.new.tap do |s|
      s.key = ENV["PAGE_SPEED_INSIGHTS_KEY"]
    end
  end

  def prometheus
    @prometheus ||= Prometheus::Client.registry
  end
end
