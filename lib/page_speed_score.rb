require "google/apis/pagespeedonline_v5"
require "prometheus/client/push"

class PageSpeedScore
  attr_reader :sitemap_url
  attr_reader :metrics

  REDIS_KEY = "app_page_speed_metrics".freeze
  STRATEGIES = %w[mobile desktop].freeze
  CATEGORIES = %w[performance accessibility seo].freeze
  FIELDS = "lighthouse_result(categories(seo/score,performance/score,accessibility/score))".freeze

  def initialize(sitemap_url)
    @sitemap_url = sitemap_url
    @metrics = {}
  end

  def fetch
    urls.product(STRATEGIES) do |url, strategy|
      options = default_options.merge!({ strategy: strategy })
      result = service.runpagespeed_pagespeedapi(url, options)
      record_metrics(result, url, strategy)
    end

    Redis.current.set(REDIS_KEY, metrics.to_json)
  end

  class << self
    def publish
      scores = Redis.current.get(PageSpeedScore::REDIS_KEY)

      return if scores.blank?

      Redis.current.del(PageSpeedScore::REDIS_KEY)

      prometheus = Prometheus::Client.registry

      JSON.parse(scores, symbolize_names: true).each do |metric_key, values|
        metric = prometheus.get(metric_key)
        values.each { |v| metric.set(v[:score], labels: v[:labels]) }
      end
    end
  end

private

  def record_metrics(result, url, strategy)
    categories = result.lighthouse_result.categories
    path = URI(url).path

    CATEGORIES.each do |category|
      key = "app_page_speed_score_#{category}".to_sym
      metrics[key] ||= []
      metrics[key] << { score: categories.send(category).score, labels: { strategy: strategy, path: path } }
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
end
