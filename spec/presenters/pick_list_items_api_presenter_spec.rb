require "rails_helper"

describe PickListItemsApiPresenter do
  let(:mock_api) { instance_double(GetIntoTeachingApiClient::PickListItemsApi) }
  let(:presenter) { described_class.new(mock_api) }

  describe "#get_candidate_journey_stages" do
    let(:allowed_ids) { [222_750_000, 222_750_003] }
    let(:api_response) do
      [
        instance_double(GetIntoTeachingApiClient::PickListItem, id: 222_750_000, value: "Allowed Stage 1"),
        instance_double(GetIntoTeachingApiClient::PickListItem, id: 222_750_003, value: "Allowed Stage 2"),
        instance_double(GetIntoTeachingApiClient::PickListItem, id: 222_750_999, value: "Not Allowed Stage"),
      ]
    end

    before do
      allow(mock_api).to receive(:get_candidate_journey_stages).and_return(api_response)
    end

    it "returns only items with allowed IDs" do
      result = presenter.get_candidate_journey_stages

      expect(result.size).to eq(2)
      expect(result.map(&:id)).to match_array(allowed_ids)
    end
  end
end
