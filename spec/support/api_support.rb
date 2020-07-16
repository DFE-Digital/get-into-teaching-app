shared_context "stub types api" do
  let(:git_api_endpoint) { ENV["GIT_API_ENDPOINT"] }
  let(:event_types) { [{ "id" => 1, "value" => "First type" }] }

  before do
    stub_request(:get, "#{git_api_endpoint}/api/types/teaching_event/types")
      .to_return \
        status: 200,
        headers: { "Content-type" => "application/json" },
        body: event_types.to_json
  end
end

shared_context "stub candidate create access token api" do
  let(:git_api_endpoint) { ENV["GIT_API_ENDPOINT"] }

  before do
    stub_request(:post, "#{git_api_endpoint}/api/candidates/access_tokens").to_return(status: 200, body: "", headers: {})
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

shared_examples "event details" do
  describe "top level event details" do
    let(:startat) { DateTime.parse eventdata["startAt"] }
    subject { event }
    it { is_expected.to be_kind_of GetIntoTeachingApi::Types::Event }
    it { is_expected.to have_attributes id: eventdata["id"] }
    it { is_expected.to have_attributes name: eventdata["name"] }
    it { is_expected.to have_attributes startAt: startat }
    it { is_expected.to have_attributes endAt: startat }
  end
end

shared_examples "event building" do
  describe "event building fields" do
    subject { event.building }
    it { is_expected.to be_kind_of GetIntoTeachingApi::Types::EventBuilding }
    it { is_expected.to have_attributes id: eventdata["building"]["id"] }
    it { is_expected.to have_attributes addressComposite: "Line 1, Line 2" }
  end
end

shared_examples "event room" do
  describe "event room fields" do
    subject { event.room }
    it { is_expected.to be_kind_of GetIntoTeachingApi::Types::EventRoom }
    it { is_expected.to have_attributes id: eventdata["room"]["id"] }
    it { is_expected.to have_attributes description: "Lecture Hall 1 description" }
  end
end

shared_examples "event entity" do
  it_behaves_like "event details"
  it_behaves_like "event building"
  it_behaves_like "event room"
end

shared_examples "array of event entities" do |length|
  subject { client.call }
  it { is_expected.to be_kind_of Array }
  it { is_expected.to have_attributes length: length }
  it { is_expected.to all respond_to :id }
  it { is_expected.to all respond_to :name }
end
