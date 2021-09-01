require "rails_helper"

describe "Google Structured Data" do
  let(:parsed_response) { Nokogiri.parse(response.body) }
  let(:json) { parsed_response.at_css("script[type='application/ld+json']").content }

  subject(:structured_data) { JSON.parse(json, symbolize_names: true) }

  context "when viewing an event page" do
    let(:event) { build(:event_api) }
    let(:path) { event_path(id: event.readable_id) }

    before do
      allow_any_instance_of(GetIntoTeachingApiClient::TeachingEventsApi).to \
        receive(:get_teaching_event) { event }
      get path
    end

    it { is_expected.to include("@type": "Event") }
  end

  context "when viewing a nested content page" do
    let(:path) { "/steps-to-become-a-teacher" }

    before { get path }

    it { is_expected.to include("@type": "BreadcrumbList") }
  end
end
