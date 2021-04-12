module Internal
  class EventBuilding
    include ActiveModel::Model
    include ActiveModel::Attributes
    include ApiModelConvertable

    attribute :id, :string
    attribute :venue, :string
    attribute :address_line1, :string
    attribute :address_line2, :string
    attribute :address_line3, :string
    attribute :address_city, :string
    attribute :address_postcode, :string

    validates :venue, presence: true, allow_blank: false
    validates :address_postcode, presence: true, postcode: true, allow_blank: false

    def self.initialize_with_api_building(building)
      hash = convert_attributes_from_api_model(building)
      new(hash)
    end

    def to_api_building
      hash = convert_attributes_for_api_model
      GetIntoTeachingApiClient::TeachingEventBuilding.new(hash)
    end
  end
end
