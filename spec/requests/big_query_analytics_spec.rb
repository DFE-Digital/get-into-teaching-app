require "rails_helper"

RSpec.describe "BigQuery Analytics", type: :request do
  it "sends a DFE Analytics web request event" do
    expect { get root_path }.to have_sent_analytics_event_types(:web_request)
  end

  it "namespaces DFE analytics web request events" do
    get root_path

    event_namespaces = enqueued_jobs
      .find { |j| j["job_class"] == "DfE::Analytics::SendEvents" }["arguments"]
      .flatten
      .map { |a| a["namespace"] }

    expect(event_namespaces).to all(eq("get_into_teaching"))
  end

  it "sends DFE Analytics entity events" do
    UserFeedback.create(attributes_for(:user_feedback))
    expect(:create_entity).to have_been_enqueued_as_analytics_events
  end
end
