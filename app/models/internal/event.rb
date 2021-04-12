module Internal
  class Event
    include ActiveModel::Model
    include ActiveModel::Attributes

    VENUE_TYPES = { add: "add", existing: "existing", none: "none" }.freeze

    attribute :id, :string
    attribute :readable_id, :string
    attribute :status_id, :integer
    attribute :type_id,
              :integer,
              default: GetIntoTeachingApiClient::Constants::EVENT_TYPES["School or University event"]
    attribute :name, :string
    attribute :summary, :string
    attribute :description, :string
    attribute :is_online, :boolean
    attribute :start_at, :datetime
    attribute :end_at, :datetime
    attribute :provider_contact_email, :string
    attribute :provider_organiser, :string
    attribute :provider_target_audience, :string
    attribute :provider_website_url, :string
    attribute :building
    attribute :venue_type, type: VENUE_TYPES, default: VENUE_TYPES[:none]

    validates :name, presence: true, allow_blank: false
    validates :readable_id, presence: true, allow_blank: false
    validates :summary, presence: true, allow_blank: false
    validates :description, presence: true, allow_blank: false
    validates :summary, presence: true, allow_blank: false
    validates :is_online, inclusion: { in: [true, false] }
    validates :start_at, presence: true, allow_blank: false
    validates :end_at, presence: true
    validates :provider_contact_email,
              presence: true,
              allow_blank: false,
              email_format: true,
              length: { maximum: 100 }
    validates :provider_organiser, presence: true, allow_blank: false
    validates :provider_target_audience, presence: true, allow_blank: false
    validates :provider_website_url, presence: true, allow_blank: false
    validates_each :start_at, :end_at do |record, attr, value|
      unless value.nil?
        record.errors.add attr, "Must be in the future" if value <= Time.zone.now
      end
    end
    validate :end_after_start

    def self.initialize_with_api_event(api_event)
      hash = api_event.to_hash.transform_keys { |k| k.to_s.underscore }.filter { |k| attribute_names.include?(k) }
      unless hash["building"].nil?
        hash["building"] = EventBuilding.initialize_with_api_building(hash["building"])
        hash["venue_type"] = VENUE_TYPES[:existing]
      end
      new(hash)
    end

    def map_to_api_event
      hash = attributes
               .filter { |k| attribute_names.include?(k) }
               .transform_keys { |k| k.to_s.camelize(:lower) }
               .filter { |_, v| v.presence }
      api_event = GetIntoTeachingApiClient::TeachingEvent.new(hash)

      if building.present?
        api_event.building = building.map_to_api_building
      end
      api_event
    end

    def persisted?
      id.present?
    end

  private

    def end_after_start
      return if end_at.blank? || start_at.blank?

      if end_at <= start_at
        errors.add(:end_at, "must be after the start date")
      end
    end

    def map_api_errors_to_attributes(response)
      JSON.parse(response.response_body)["errors"].each do |key, value|
        errors.add(key.underscore.to_sym, value[0])
      end
    end
  end
end
