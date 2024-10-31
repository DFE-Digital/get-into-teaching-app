require "rails_helper"

describe "Google Tag Manager", type: :request do
  include_context "with wizard data"

  let(:event) { build(:event_api) }
  let(:layout_paths) do
    [
      "/cookies",
      "/steps-to-become-a-teacher",
      "/ways_to_train",
      "/welcome",
      blog_path("my-career-change-to-teaching"),
      blog_index_path,
      event_path(event.readable_id),
      event_step_path(event.readable_id, :personal_details),
      event_step_path(event.readable_id, :further_details),
      events_path,
      event_path(event.readable_id),
      root_path,
    ]
  end

  before do
    allow_any_instance_of(GetIntoTeachingApiClient::TeachingEventsApi).to \
      receive(:get_teaching_event).with(event.readable_id) { event }
    allow_any_instance_of(GetIntoTeachingApiClient::TeachingEventsApi).to \
      receive(:search_teaching_events).and_return([])
  end

  it "has the GTM and fallback scripts" do
    layout_paths.each do |layout_path|
      get layout_path
      expect(response.body).to include("data-gtm-id=\"123-ABC\""), "#{layout_path} does not include GTM"
      expect(response.body).to include("https://www.googletagmanager.com/ns.html"), "#{layout_path} does not include GTM fallback"
    end
  end

  context "when the GTM_ID is not set" do
    before do
      allow(ENV).to receive(:[]).and_call_original
      allow(ENV).to receive(:[]).with("GTM_ID").and_return(nil)
    end

    it "does not have the GTM and fallback scripts" do
      layout_paths.each do |layout_path|
        get layout_path
        expect(response.body).not_to include("data-gtm-id"), "#{layout_path} does not include GTM"
        expect(response.body).not_to include("https://www.googletagmanager.com/ns.html"), "#{layout_path} does not include GTM fallback"
      end
    end
  end
end
