require "rails_helper"

RSpec.describe "BigQuery Analytics", type: :request do
  it "sends a DFE Analytics web request event" do
    expect { get root_path }.to have_sent_analytics_event_types(:web_request)
  end

  it "sends DFE Analytics entity events" do
    params = { teacher_training_adviser_feedback: attributes_for(:feedback) }
    post teacher_training_adviser_feedbacks_path, params: params
    expect(:create_entity).to have_been_enqueued_as_analytics_events
  end
end
