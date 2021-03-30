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
    let(:expected_metrics) { {} }

    before do
      allow(ENV).to receive(:[]).and_call_original
      expect(ENV).to receive(:[]).with("PAGE_SPEED_INSIGHTS_KEY") { "12345" }
    end

    it "retrieves the scores for each page/strategy combination and caches them in Redis" do
      stub_request(:get, "https://example.com/sitemap.xml")
        .to_return(status: 200, body: sitemap_xml)

      expect_page_scores("page1")
      expect_page_scores("page2")

      expect(Redis.current).to receive(:set)
        .with("app_page_speed_metrics", expected_metrics.to_json)

      subject.fetch

      expect(subject.metrics).to eq(expected_metrics)
    end
  end

  describe ".publish" do
    context "when there are no scores to publish" do
      before do
        expect(Redis.current).to receive(:get).with(described_class::REDIS_KEY) { nil }
      end

      it "does not call Prometheus" do
        expect(Prometheus::Client).to_not receive(:registry)
        described_class.publish
      end
    end

    context "when there are scores to publish" do
      let(:prometheus) { Prometheus::Client.registry }
      let(:test_metrics) do
        {
          "app_page_speed_score_seo" => [
            { score: 56, labels: { strategy: "mobile", path: "/test/page" } },
          ],
        }
      end

      it "deletes from Redis then sends the scores to Prometheus" do
        expect(Redis.current).to receive(:get).with(described_class::REDIS_KEY) { test_metrics.to_json }
        expect(Redis.current).to receive(:del).with(described_class::REDIS_KEY)

        metric = prometheus.get(:app_page_speed_score_seo)
        expect(metric).to receive(:set).with(56, labels: { strategy: "mobile", path: "/test/page" }).once

        described_class.publish
      end
    end
  end
end

def expect_page_scores(page)
  described_class::STRATEGIES.each do |strategy|
    scores = { performance: rand(100), accessibility: rand(100), seo: rand(100) }
    expect_page_speed_score_request(page, strategy, scores)
    update_expected_metrics(page, strategy, scores)
  end
end

def update_expected_metrics(page, strategy, scores)
  scores.each do |category, score|
    key = "app_page_speed_score_#{category}".to_sym
    expected_metrics[key] ||= []
    expected_metrics[key] << { score: score, labels: { strategy: strategy, path: "/#{page}" } }
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
