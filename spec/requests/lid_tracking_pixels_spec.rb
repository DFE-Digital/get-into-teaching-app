require "rails_helper"

describe "LID tracking pixels" do
  before do
    allow_any_instance_of(GetIntoTeachingApiClient::TeachingEventsApi).to \
      receive(:upcoming_teaching_events_indexed_by_type) { {} }
  end

  before { get path }
  subject { response.body }

  context "when visiting /" do
    let(:path) { root_path }

    it { is_expected.to include_analytics("lid", { action: "track", event: "Homepage" }) }
  end

  context "when visiting /events" do
    let(:path) { events_path }

    it { is_expected.to include_analytics("lid", { action: "track", event: "Events" }) }
  end

  context "when visiting /mailinglist/signup/completed" do
    let(:path) { completed_mailing_list_steps_path }

    it { is_expected.to include_analytics("lid", { action: "track", event: "MailingList" }) }
  end
end
