require "rails_helper"

describe GetIntoTeachingApi::SearchEvents do
  include_context "stub types api"

  let(:token) { "test123" }
  let(:endpoint) { "http://my.api/api" }
  let(:response_headers) { { "Content-Type" => "application/json" } }
  let(:api_params) { { token: token, endpoint: endpoint } }
  let(:search_params) do
    {
      "TypeId" => 222_750_001,
      "Radius" => 30,
      "Postcode" => "TE571NG",
      "StartAfter" => /2020-07-01/,
      "StartBefore" => /2020-07-31/,
    }
  end
  let(:client) do
    described_class.new(**api_params.merge(
      type_id: 222_750_001,
      radius: 30,
      postcode: "TE571NG",
      start_after: DateTime.parse("2020-07-01T00:00:00"),
      start_before: DateTime.parse("2020-07-31T23:59:59"),
    ))
  end
  let(:testdata) { build_list :event_api, 1 }

  xdescribe "#events" do
    before do
      stub_request(:get, "#{endpoint}/teaching_events/search")
        .with(query: search_params)
        .to_return \
          status: 200,
          headers: response_headers,
          body: testdata.to_json
    end

    it_behaves_like "array of event entities", 1

    describe "first entity" do
      let(:eventdata) { testdata[0] }
      let(:event) { client.call.first }
      it_behaves_like "event entity"
    end
  end
end
