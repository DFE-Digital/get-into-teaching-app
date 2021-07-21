module Internal
  class EventBuilding
    include ActiveModel::Model
    include ActiveModel::Attributes
    include ApiModelConvertible

    attribute :id, :string
    attribute :venue, :string
    attribute :address_line1, :string
    attribute :address_line2, :string
    attribute :address_line3, :string
    attribute :address_city, :string
    attribute :address_postcode, :string
    attribute :image_url, :string

    validates :venue, presence: true, allow_blank: false, length: { maximum: 100 }
    validates :address_line1, length: { maximum: 255 }
    validates :address_line2, length: { maximum: 255 }
    validates :address_line3, length: { maximum: 255 }
    validates :address_city, length: { maximum: 100 }
    validates :address_postcode, presence: true, postcode: true, allow_blank: false, length: { maximum: 100 }

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
