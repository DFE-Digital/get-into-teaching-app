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

shared_examples "event details" do
  describe "top level event details" do
    let(:startdate) { Date.parse eventdata["startDate"] }
    subject { event }
    it { is_expected.to be_kind_of GetIntoTeachingApi::Types::Event }
    it { is_expected.to have_attributes eventId: eventdata["eventId"] }
    it { is_expected.to have_attributes eventName: eventdata["eventName"] }
    it { is_expected.to have_attributes startDate: startdate }
    it { is_expected.to have_attributes endDate: startdate }
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
  it { is_expected.to all respond_to :eventId }
  it { is_expected.to all respond_to :eventName }
end
