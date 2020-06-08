require "rails_helper"

describe GetIntoTeachingApi::SearchEvents do
  include_context "stub types api"

  let(:token) { "test123" }
  let(:endpoint) { "http://my.api/api" }
  let(:response_headers) { { "Content-Type" => "application/json" } }
  let(:api_params) { { token: token, endpoint: endpoint } }
  let(:search_params) { attributes_for :events_search }
  let(:client) { described_class.new(**api_params.merge(search_params)) }
  let(:testdata) do
    build_list :event_api, 1, eventName: "Become a teacher", startDate: "2020-05-18"
  end

  describe "#events" do
    before do
      stub_request(:get, "#{endpoint}/teaching_events/search")
        .with(query: search_params)
        .to_return \
          status: 200,
          headers: response_headers,
          body: testdata.to_json
    end

    subject { client.call }

    it { is_expected.to be_kind_of Array }
    it { is_expected.to have_attributes length: 1 }
    it { is_expected.to all respond_to :eventId }
    it { is_expected.to all respond_to :eventName }

    context "event details" do
      subject { client.call.first }
      it { is_expected.to be_kind_of GetIntoTeachingApi::Types::Event }
      it { is_expected.to have_attributes eventId: testdata[0]["eventId"] }
      it { is_expected.to have_attributes eventName: "Become a teacher" }
      it { is_expected.to have_attributes startDate: Date.parse("2020-05-18") }
      it { is_expected.to have_attributes endDate: Date.parse("2020-05-18") }
    end

    context "event building" do
      subject { client.call.first.building }
      it { is_expected.to be_kind_of GetIntoTeachingApi::Types::EventBuilding }
      it { is_expected.to have_attributes id: testdata[0]["building"]["id"] }
      it { is_expected.to have_attributes addressComposite: "Line 1, Line 2" }
    end

    context "event room" do
      subject { client.call.first.room }
      it { is_expected.to be_kind_of GetIntoTeachingApi::Types::EventRoom }
      it { is_expected.to have_attributes id: testdata[0]["room"]["id"] }
      it { is_expected.to have_attributes description: "Lecture Hall 1 description" }
    end
  end
end
