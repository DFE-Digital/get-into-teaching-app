require "rails_helper"

describe "LID tracking pixels", type: :request do
  subject do
    get path
    response.body
  end

  before do
    allow(Rails.application.config.x).to receive(:legacy_tracking_pixels).and_return(true)
    allow_any_instance_of(GetIntoTeachingApiClient::TeachingEventsApi).to \
      receive(:search_teaching_events_grouped_by_type).and_return([])
  end

  context "when visiting /events" do
    let(:path) { events_path }

    it { is_expected.to include_analytics("lid", { action: "track", event: "Events" }) }
  end

  context "when visiting /mailinglist/signup/completed" do
    let(:path) { completed_mailing_list_steps_path }

    it { is_expected.to include_analytics("lid", { action: "track", event: "MailingList" }) }
  end

  context "when visiting a content page" do
    let(:path) { "/tracked-page" }

    it { is_expected.to include_analytics("lid", { action: "track", event: "EventName" }) }
  end

  context "when visiting /steps-to-become-a-teacher" do
    let(:path) { "/steps-to-become-a-teacher" }

    it { is_expected.to include_analytics("lid", { action: "track", event: "Steps" }) }
  end

  context "when legacy tracking is disabled" do
    before { allow(Rails.application.config.x).to receive(:legacy_tracking_pixels).and_return(false) }

    context "when visiting /events" do
      let(:path) { events_path }

      it { is_expected.not_to include_analytics("lid", { action: "track", event: "Events" }) }
    end

    context "when visiting /mailinglist/signup/completed" do
      let(:path) { completed_mailing_list_steps_path }

      it { is_expected.not_to include_analytics("lid", { action: "track", event: "MailingList" }) }
    end

    context "when visiting a content page" do
      let(:path) { "/tracked-page" }

      it { is_expected.not_to include_analytics("lid", { action: "track", event: "EventName" }) }
    end

    context "when visiting /steps-to-become-a-teacher" do
      let(:path) { "/steps-to-become-a-teacher" }

      it { is_expected.not_to include_analytics("lid", { action: "track", event: "Steps" }) }
    end
  end
end
