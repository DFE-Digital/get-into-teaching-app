require "rails_helper"

describe GetIntoTeachingApi::Event do
  let(:token) { "test123" }
  let(:endpoint) { "http://my.api/api" }
  let(:response_headers) { { "Content-Type" => "application/json" } }
  let(:client) do
    described_class.new event_id: event_id, token: token, endpoint: endpoint
  end
  let(:event_id) { SecureRandom.uuid }
  let(:building_id) { SecureRandom.uuid }
  let(:room_id) { SecureRandom.uuid }
  let(:testdata) do
    {
      "eventId": event_id,
      "readableEventId": event_id,
      "eventName": "Become a teacher",
      "description": "Become a teacher",
      "startDate": "2020-05-18",
      "endDate": "2020-05-18",
      "eventType": 0,
      "maxCapacity": 10,
      "publicEventUrl": "https://event.url",
      "building": {
        "id": building_id,
        "accessibleToilets": true,
        "additionalFacilities": "string",
        "addressComposite": "Line 1, Line 2",
        "addressLine1": "Line 1",
        "addressLine2": "Line 2",
        "addressLine3": nil,
        "city": "Manchestr",
        "stateProvince": "Greater Manchester",
        "country": "United Kingdom",
        "postalCode": "MA1 1AM",
        "description": "Main Lecture Halls Building",
        "disabledAccess": true,
        "disabledParking": true,
        "publicTelephoneAvailable": true,
        "email": "first@someone.com",
        "name": "First Contact",
        "telephone1": "01234567890",
        "telephone2": nil,
        "telephone3": nil,
        "website": nil,
        "wifiAvailable": true,
      },
      "room": {
        "id": room_id,
        "description": "Lecture Hall 1",
        "name": "Lecture Hall 1",
        "disabledAccess": true,
      },
    }
  end

  describe "#event" do
    before do
      stub_request(:get, "#{endpoint}/teaching_events/#{event_id}").to_return \
        status: 200,
        headers: response_headers,
        body: testdata.to_json
    end

    subject { client.call }

    it { is_expected.to be_kind_of GetIntoTeachingApi::Types::Event }
    it { is_expected.to respond_to :eventId }
    it { is_expected.to respond_to :eventName }
    it { is_expected.to respond_to :building }
    it { is_expected.to respond_to :room }
  end
end
