require "rails_helper"

describe GetIntoTeachingApi::SearchEvents do
  include_context "stub types api"

  let(:token) { "test123" }
  let(:endpoint) { "http://my.api/api" }
  let(:response_headers) { { "Content-Type" => "application/json" } }
  let(:api_params) { { token: token, endpoint: endpoint } }
  let(:search_params) { attributes_for :events_search }
  let(:client) { described_class.new(**api_params.merge(search_params)) }
  let(:testdata) { build_list :event_api, 1 }

  describe "#events" do
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
