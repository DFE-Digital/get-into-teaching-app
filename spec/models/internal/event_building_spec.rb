require "rails_helper"

describe Internal::EventBuilding do
  describe "attributes" do
    it { is_expected.to respond_to :id }
    it { is_expected.to respond_to :venue }
    it { is_expected.to respond_to :address_line1 }
    it { is_expected.to respond_to :address_line2 }
    it { is_expected.to respond_to :address_line3 }
    it { is_expected.to respond_to :address_city }
    it { is_expected.to respond_to :address_postcode }
  end

  describe "#initialize" do
    context "with GetIntoTeachingApiClient::TeachingEvent" do
      let(:api_building) { build(:event_building_api) }
      let(:expected_attributes) do
        attributes_for(
          :event_building_api,
          id: api_building.id,
          venue: api_building.venue,
          address_line1: api_building.address_line1,
          address_line2: api_building.address_line2,
          address_line3: api_building.address_line3,
          address_city: api_building.address_city,
          address_postcode: api_building.address_postcode,
        )
      end
      it "should have correct attributes" do
        expect(described_class.initialize_with_api_building(api_building)).to have_attributes(expected_attributes)
      end
    end
  end
end
