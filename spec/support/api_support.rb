shared_context "stub types api" do
  let(:git_api_endpoint) { ENV["GIT_API_ENDPOINT"] }
  let(:stub_types) { [{ "id" => 1, "value" => "First type" }] }

  before do
    stub_request(:get, "#{git_api_endpoint}/api/types/teaching_event/types")
      .to_return \
        status: 200,
        headers: { "Content-type" => "application/json" },
        body: stub_types.to_json

    stub_request(:get, "#{git_api_endpoint}/api/types/qualification/degree_status")
      .to_return \
        status: 200,
        headers: { "Content-type" => "application/json" },
        body: GetIntoTeachingApiClient::Constants::DEGREE_STATUS_OPTIONS.map { |k, v| { id: v, value: k } }.to_json

    stub_request(:get, "#{git_api_endpoint}/api/types/candidate/consideration_journey_stages")
      .to_return \
        status: 200,
        headers: { "Content-type" => "application/json" },
        body: GetIntoTeachingApiClient::Constants::CONSIDERATION_JOURNEY_STAGES.map { |k, v| { id: v, value: k } }.to_json

    stub_request(:get, "#{git_api_endpoint}/api/types/teaching_event/types")
      .to_return \
        status: 200,
        headers: { "Content-type" => "application/json" },
        body: GetIntoTeachingApiClient::Constants::EVENT_TYPES.map { |k, v| { id: v, value: k } }.to_json

    stub_request(:get, "#{git_api_endpoint}/api/types/teaching_subjects")
      .to_return \
        status: 200,
        headers: { "Content-type" => "application/json" },
        body: GetIntoTeachingApiClient::Constants::TEACHING_SUBJECTS.map { |k, v| { id: v, value: k } }.to_json
  end
end

shared_context "stub candidate create access token api" do
  let(:git_api_endpoint) { ENV["GIT_API_ENDPOINT"] }

  before do
    stub_request(:post, "#{git_api_endpoint}/api/candidates/access_tokens").to_return(status: 200, body: "", headers: {})
  end
end

shared_context "stub latest privacy policy api" do
  let(:git_api_endpoint) { ENV["GIT_API_ENDPOINT"] }
  let(:policy) { [{ "id" => "abc123" }] }

  before do
    stub_request(:get, "#{git_api_endpoint}/api/privacy_policies/latest").to_return(status: 200, body: policy.to_json, headers: {})
  end
end

shared_context "stub event add attendee api" do
  let(:git_api_endpoint) { ENV["GIT_API_ENDPOINT"] }

  before do
    stub_request(:post, "#{git_api_endpoint}/api/teaching_events/attendees").to_return(status: 200, body: "", headers: {})
  end
end

shared_context "stub mailing list add member api" do
  let(:git_api_endpoint) { ENV["GIT_API_ENDPOINT"] }

  before do
    stub_request(:post, "#{git_api_endpoint}/api/mailing_list/members").to_return(status: 200, body: "", headers: {})
  end
end

shared_context "stub events by category api" do |results_per_type|
  let(:events) { [build(:event_api, name: "First"), build(:event_api, name: "Second")] }
  let(:events_by_type) { events.group_by { |event| event.type_id.to_s.to_sym } }
  let(:expected_request_attributes) { { quantity_per_type: results_per_type } }

  before do
    expect_any_instance_of(GetIntoTeachingApiClient::TeachingEventsApi).to \
      receive(:upcoming_teaching_events_indexed_by_type)
      .with(a_hash_including(expected_request_attributes)) { events_by_type }
  end
end

shared_examples "api support" do
  let(:token) { "test123" }
  let(:endpoint) { "http://my.api/api" }
  let(:response_headers) { { "Content-Type" => "application/json" } }
  let(:client) { described_class.new(token: token, endpoint: endpoint) }

  subject { client.call }

  before do
    stub_request(:get, "#{endpoint}/#{apicall}").to_return \
      status: 200,
      headers: response_headers,
      body: testdata.to_json
  end
end
