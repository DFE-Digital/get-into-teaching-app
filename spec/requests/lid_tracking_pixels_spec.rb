require "rails_helper"

describe "LID tracking pixels", type: :request do
  before do
    allow_any_instance_of(GetIntoTeachingApiClient::TeachingEventsApi).to \
      receive(:search_teaching_events_grouped_by_type) { [] }
  end

  before { get path }

  subject { response.body }

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
end
