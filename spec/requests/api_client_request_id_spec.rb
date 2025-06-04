require "rails_helper"

RSpec.describe "API client request_id", type: :request do
  let(:uuid) { "56b2d75b-2407-4131-bb5c-83e2d8ee0cf1" }

  it "passes the request_id to the API client" do
    api_client_double = class_double(GetIntoTeachingApiClient::Current, request_id: uuid)
                          .as_stubbed_const(transfer_nested_constants: true)
    allow_any_instance_of(ActionDispatch::Request).to receive(:uuid) { uuid }
    expect(api_client_double).to receive(:request_id=).with(uuid).once
    get root_path
  end
end
