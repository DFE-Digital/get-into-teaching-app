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

  describe "validations" do
    describe "#venue" do
      it { is_expected.to allow_value("test").for :venue }
      it { is_expected.to_not allow_value("").for :venue }
      it { is_expected.to_not allow_value(nil).for :venue }
      it { is_expected.to validate_length_of(:venue).is_at_most(100) }
    end

    describe "#address_line1" do
      it { is_expected.to validate_length_of(:address_line1).is_at_most(255) }
    end

    describe "#address_line2" do
      it { is_expected.to validate_length_of(:address_line2).is_at_most(255) }
    end

    describe "#address_line3" do
      it { is_expected.to validate_length_of(:address_line3).is_at_most(255) }
    end

    describe "#address_city" do
      it { is_expected.to validate_length_of(:address_city).is_at_most(100) }
    end

    describe "#address_postcode" do
      it { is_expected.to allow_value("M1 7AX").for :address_postcode }
      it { is_expected.to_not allow_value("not a postcode").for :address_postcode }
      it { is_expected.to_not allow_value("").for :address_postcode }
      it { is_expected.to_not allow_value(nil).for :address_postcode }
      it { is_expected.to validate_length_of(:address_postcode).is_at_most(100) }
    end
  end

  describe "#initialize_with_api_building" do
    let(:api_building) { build(:event_building_api) }
    let(:expected_attributes) do
      attributes_for(
        :event_building,
        id: api_building.id,
        venue: api_building.venue,
        address_line1: api_building.address_line1,
        address_line2: api_building.address_line2,
        address_line3: api_building.address_line3,
        address_city: api_building.address_city,
        address_postcode: api_building.address_postcode,
        image_url: api_building.image_url,
      )
    end

    it "has correct attributes" do
      expect(described_class.initialize_with_api_building(api_building)).to have_attributes(expected_attributes)
    end
  end

  describe "#to_api_building" do
    let(:internal_building) { build(:event_building) }
    let(:expected_api_building_attributes) do
      attributes_for(
        :event_building_api,
        id: internal_building.id,
        venue: internal_building.venue,
        address_line1: internal_building.address_line1,
        address_line2: internal_building.address_line2,
        address_line3: internal_building.address_line3,
        address_city: internal_building.address_city,
        address_postcode: internal_building.address_postcode,
      )
    end

    it "has correct attributes" do
      expect(internal_building.to_api_building).to have_attributes(expected_api_building_attributes)
    end
  end
end
