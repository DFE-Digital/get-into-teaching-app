require "rails_helper"

describe "Google Tag Manager", type: :request do
  include_context "with wizard data"

  let(:event) { build(:event_api) }
  let(:layout_paths) do
    [
      "/cookies",
      "/my-story-into-teaching",
      "/my-story-into-teaching/career-changers/financiers-future-in-maths",
      "/my-story-into-teaching/internaltional-career-changers",
      "/steps-to-become-a-teacher",
      "/three-things-to-help-you-get-into-teaching",
      "/ways_to_train",
      "/welcome",
      blog_path("choosing-the-right-teacher-training-course-provider"),
      blog_index_path,
      event_path(event.readable_id),
      event_step_path(event.readable_id, :personal_details),
      events_path,
      root_path,
    ]
  end

  before do
    allow_any_instance_of(GetIntoTeachingApiClient::TeachingEventsApi).to \
      receive(:get_teaching_event).with(event.readable_id) { event }
    allow_any_instance_of(GetIntoTeachingApiClient::TeachingEventsApi).to \
      receive(:search_teaching_events_grouped_by_type).and_return([])
    allow(Rails.application.config.x).to receive(:legacy_tracking_pixels) { legacy_tracking_pixels }
  end

  context "when legacy tracking pixels are disabled" do
    let(:legacy_tracking_pixels) { false }

    it "has the GTM and fallback scripts" do
      layout_paths.each do |layout_path|
        get layout_path
        expect(response.body).to include("data-gtm-id=\"123-ABC\""), "#{layout_path} does not include GTM"
        expect(response.body).to include("https://www.googletagmanager.com/ns.html"), "#{layout_path} does not include GTM fallback"
      end
    end
  end

  context "when legacy tracking pixels are enabled" do
    let(:legacy_tracking_pixels) { true }

    it "does not have the GTM and fallback scripts" do
      layout_paths.each do |layout_path|
        get layout_path
        expect(response.body).not_to include("data-gtm-id"), "#{layout_path} does not include GTM"
        expect(response.body).not_to include("https://www.googletagmanager.com/ns.html"), "#{layout_path} does not include GTM fallback"
      end
    end
  end
end
