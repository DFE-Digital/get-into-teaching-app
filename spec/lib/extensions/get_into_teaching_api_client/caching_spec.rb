require "rails_helper"

describe Extensions::GetIntoTeachingApiClient::Caching do
  let(:get_endpoint) { "https://host.api/endpoint/api/types/candidate/channels" }
  let(:post_endpoint) { "https://host.api/endpoint/api/candidates/access_tokens" }
  let(:token) { "test" }
  let(:data) { [{ id: 123, value: "test" }] }

  def perform_get_request
    GetIntoTeachingApiClient::TypesApi.new.get_candidate_channels
  end

  def perform_post_request
    existing_candidate = GetIntoTeachingApiClient::ExistingCandidateRequest.new(email: "test@test.com")
    GetIntoTeachingApiClient::CandidatesApi.new.create_candidate_access_token(existing_candidate)
  end

  context "when caching is enabled" do
    let(:memory_store) { ActiveSupport::Cache.lookup_store(:memory_store) }

    before do
      allow(Rails).to receive(:cache).and_return(memory_store)
      Rails.cache.clear
    end

    it "does not override responses with a blanket Cache-Control header if no ETag was present" do
      stub = stub_request(:get, get_endpoint)
      .to_return(status: 200, body: data.to_json)

      perform_get_request
      perform_get_request

      expect(stub).to have_been_requested.times(2)
    end

    it "overrides responses that have ETags with a blanket Cache-Control header" do
      stub = stub_request(:get, get_endpoint)
        .to_return(status: 200, body: data.to_json, headers: { ETag: "123" })

      perform_get_request
      perform_get_request

      expect(stub).to have_been_requested.times(1)
    end
  end

  it "performs a POST request successfully" do
    stub_request(:post, post_endpoint)
      .with(body: { email: "test@test.com" })
      .to_return(status: 200, body: data.to_json)

    expect { perform_post_request }.to_not raise_error
  end

  it "performs a GET request successfully" do
    stub_request(:get, get_endpoint)
      .to_return(status: 200, body: data.to_json)

    result = perform_get_request
    type = result.first
    expect(type).to be_instance_of(GetIntoTeachingApiClient::TypeEntity)
    expect(type).to have_attributes({ id: "123", value: "test" })
  end

  it "raises an ApiError if the request fails" do
    stub_request(:get, get_endpoint)
      .to_return(status: 500)

    expect { perform_get_request }.to raise_error(GetIntoTeachingApiClient::ApiError)
  end

  it "sets an Authorization header on the request" do
    stub_request(:get, get_endpoint)
      .with(headers: { "Authorization" => "Bearer #{token}" })
      .to_return \
        status: 200,
        body: data.to_json

    expect { perform_get_request }.to_not raise_error
  end

  it "retries a failed request" do
    stub_request(:get, get_endpoint)
      .to_timeout
      .then
      .to_return(status: 200, body: data.to_json)

    expect { perform_get_request }.to_not raise_error
  end

  it "gives up after the first retry" do
    stub_request(:get, get_endpoint)
      .to_timeout
      .then
      .to_timeout
      .then
      .to_return(status: 200, body: data.to_json)

    expect { perform_get_request }.to raise_error(Faraday::ConnectionFailed)
  end
end
