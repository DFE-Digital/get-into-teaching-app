require "rails_helper"

RSpec.describe "BigQuery Analytics", type: :request do
  it "sends a DFE Analytics web request event" do
    expect { get root_path }.to have_sent_analytics_event_types(:web_request)
  end
end
