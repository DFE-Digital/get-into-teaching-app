module Internal
  class EventBuilding
    include ActiveModel::Model
    include ActiveModel::Attributes

    attribute :id, :string
    attribute :venue, :string
    attribute :address_line1, :string
    attribute :address_line2, :string
    attribute :address_line3, :string
    attribute :address_city, :string
    attribute :address_postcode, :string

    def self.initialize_with_api_building(building)
      hash = building.to_hash.transform_keys { |k| k.to_s.underscore }.filter { |k| attribute_names.include?(k) }
      new(hash)
    end

    def map_to_api_building
      hash = attributes
               .filter { |k| attribute_names.include?(k) }
               .transform_keys { |k| k.to_s.camelize(:lower) }
               .filter { |_, v| v.presence }
      GetIntoTeachingApiClient::TeachingEventBuilding.new(hash)
    end
  end
end
