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

  # TODO: Need to understand if this is still required
  xit "sends DFE Analytics entity events" do
    params = { teacher_training_adviser_feedback: attributes_for(:user_feedback) }
    post feedbacks_path, params: params
    expect(:create_entity).to have_been_enqueued_as_analytics_events
  end
end
