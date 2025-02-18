require 'rails_helper'

describe PicklistItemsApiPresenter do
  let(:mock_api) { double('GetIntoTeachingApiClient::PickListItemsApi') }
  let(:presenter) { described_class.new(mock_api) }

  describe '#get_candidate_journey_stages' do
    let(:allowed_ids) { [222_750_000, 222_750_003] }
    let(:api_response) do
      [
        double('Item', id: 222_750_000, name: 'Allowed Stage 1'),
        double('Item', id: 222_750_003, name: 'Allowed Stage 2'),
        double('Item', id: 222_750_999, name: 'Not Allowed Stage')
      ]
    end
    before do
      allow(mock_api).to receive(:get_candidate_journey_stages).and_return(api_response)
    end

    it 'returns only items with allowed IDs' do
      result = presenter.get_candidate_journey_stages

      expect(result.size).to eq(2)
      expect(result.map(&:id)).to match_array(allowed_ids)
    end
  end
end
