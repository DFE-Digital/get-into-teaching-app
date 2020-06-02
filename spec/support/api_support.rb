shared_context "stub types api" do
  let(:event_types) { [{ "id" => 1, "value" => "First type" }] }

  before do
    allow_any_instance_of(GetIntoTeachingApi::EventTypes).to \
      receive(:data).and_return event_types
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
