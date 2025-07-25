require "rails_helper"

describe "Google Structured Data", type: :request do
  subject(:structured_data) { json_contents.map { |json| JSON.parse(json, symbolize_names: true) } }

  let(:parsed_response) { Nokogiri.parse(response.body) }
  let(:json_contents) { parsed_response.css("script[type='application/ld+json']").map(&:content) }

  before do
    %i[event organization breadcrumb_list web_site].each do |type|
      allow(Rails.application.config.x.structured_data).to \
        receive(type).and_return(true)
    end
  end

  context "when viewing an event page" do
    include_context "with stubbed accessibility options api"

    let(:event) { build(:event_api) }
    let(:path) { event_path(id: event.readable_id) }

    before do
      allow_any_instance_of(GetIntoTeachingApiClient::TeachingEventsApi).to \
        receive(:get_teaching_event) { event }
      get path
    end

    it { is_expected.to include(a_hash_including("@type": "Event")) }
  end

  context "when viewing a nested content page" do
    let(:path) { "/steps-to-become-a-teacher" }

    before { get path }

    it { is_expected.to include(a_hash_including("@type": "BreadcrumbList")) }
  end

  context "when viewing a page" do
    let(:path) { "/train-to-be-a-teacher" }

    before { get path }

    it { is_expected.to include(a_hash_including("@type": "Organization")) }
  end

  context "when viewing the home page" do
    let(:path) { root_path }

    before { get path }

    it { is_expected.to include(a_hash_including("@type": "Organization")) }
  end

  context "when not viewing the home page" do
    let(:path) { "/train-to-be-a-teacher" }

    before { get path }

    it { is_expected.not_to include(a_hash_including("@type": "WebSite")) }
  end
end
