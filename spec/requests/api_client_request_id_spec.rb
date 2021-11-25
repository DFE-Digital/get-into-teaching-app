require "rails_helper"

RSpec.describe "API client request_id", type: :request do
  it "passes the request_id to the API client" do
    uuid = "56b2d75b-2407-4131-bb5c-83e2d8ee0cf1"
    allow_any_instance_of(ActionDispatch::Request).to receive(:uuid) { uuid }
    expect_any_instance_of(GetIntoTeachingApiClient::Current).to receive(:request_id=).with(uuid).once
    get root_path
  end
end
