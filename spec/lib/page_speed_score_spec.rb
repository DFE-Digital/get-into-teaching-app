require "rails_helper"
require "page_speed_score"

describe PageSpeedScore do
  let(:host) { "https://example.com" }
  let(:sitemap_url) { "#{host}/sitemap.xml" }

  subject { described_class.new(sitemap_url) }

  describe "#sitemap_url" do
    it { expect(subject.sitemap_url).to eq(sitemap_url) }
  end

  describe "#fetch" do
    let(:sitemap_xml) { file_fixture("sitemap.xml").read }
    let(:prometheus) { Prometheus::Client.registry }

    before do
      allow(Rails.application.credentials).to \
        receive(:page_speed_insights_key) { "12345" }
    end

    it "retrieves the scores for each page/strategy combination and sends them to prometheus" do
      stub_request(:get, "https://example.com/sitemap.xml")
        .to_return(status: 200, body: sitemap_xml)

      expect_page_scores("page1")
      expect_page_scores("page2")

      subject.fetch
    end
  end
end

def expect_page_scores(page)
  described_class::STRATEGIES.each do |strategy|
    scores = { performance: rand(100), accessibility: rand(100), seo: rand(100) }
    expect_page_speed_score_request(page, strategy, scores)
    expect_metric_set(page, strategy, scores)
  end
end

def expect_metric_set(page, strategy, scores)
  scores.each do |category, score|
    metric = prometheus.get("app_page_speed_score_#{category}".to_sym)
    expect(metric).to receive(:set).with(score, labels: { strategy: strategy, path: "/#{page}" })
  end
end

def expect_page_speed_score_request(page, strategy, scores)
  expect_any_instance_of(Google::Apis::PagespeedonlineV5::PagespeedInsightsService)
    .to receive(:runpagespeed_pagespeedapi).with(
      "#{host}/#{page}",
      {
        category: described_class::CATEGORIES,
        strategy: strategy,
        fields: described_class::FIELDS,
      },
    ) { mock_response(scores) }
end

def mock_response(scores)
  Google::Apis::PagespeedonlineV5::PagespeedApiPagespeedResponseV5.new.tap do |r|
    scores.each do |category, score|
      allow(r).to receive_message_chain("lighthouse_result.categories.#{category}.score") { score } # rubocop:disable RSpec/MessageChain
    end
  end
end
