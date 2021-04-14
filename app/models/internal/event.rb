module Internal
  class Event
    include ActiveModel::Model
    include ActiveModel::Attributes
    include ApiModelConvertible

    VENUE_TYPES = { add: "add", existing: "existing", none: "none" }.freeze

    attribute :id, :string
    attribute :readable_id, :string
    attribute :status_id,
              :integer,
              default: GetIntoTeachingApiClient::Constants::EVENT_STATUS["Pending"]
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

    def initialize(attributes = {})
      super
      self.building = initialize_building(attributes[:venue_type], attributes[:building] || {})
    end

    def self.initialize_with_api_event(api_event)
      hash = convert_attributes_from_api_model(api_event)
      unless hash["building"].nil?
        hash["building"] = EventBuilding.initialize_with_api_building(hash["building"])
        hash["venue_type"] = VENUE_TYPES[:existing]
      end
      new(hash)
    end

    def to_api_event
      hash = convert_attributes_for_api_model
      api_event = GetIntoTeachingApiClient::TeachingEvent.new(hash)

      api_event.building = building.to_api_building if building.present?
      api_event
    end

    def persisted?
      id.present?
    end

    def save
      return false if invalid?

      GetIntoTeachingApiClient::TeachingEventsApi.new.upsert_teaching_event(to_api_event)
      true
    rescue GetIntoTeachingApiClient::ApiError => e
      map_api_errors_to_attributes(e) if e.code == 400
      false
    end

    def map_api_errors_to_attributes(response)
      JSON.parse(response.response_body)["errors"].each do |key, value|
        errors.add(key.underscore.to_sym, value[0])
      end
    end

    def buildings
      @buildings ||= GetIntoTeachingApiClient::TeachingEventBuildingsApi
        .new.get_teaching_event_buildings
    end

    def valid?(context = nil)
      super && (building.nil? || building.valid?)
    end

  private

    def initialize_building(venue_type, attributes = {})
      existing_building = venue_type == VENUE_TYPES[:existing] && attributes[:id].present?
      new_building = venue_type == VENUE_TYPES[:add]

      if existing_building
        initialize_building_with_id(attributes[:id])
      elsif new_building
        # Id may be present on hidden field from previous selection.
        EventBuilding.new(attributes.merge({ id: nil }).to_hash)
      end
    end

    def initialize_building_with_id(id)
      api_building = buildings.find { |b| b.id == id }
      EventBuilding.initialize_with_api_building(api_building)
    end

    def end_after_start
      return if end_at.blank? || start_at.blank?

      if end_at <= start_at
        errors.add(:end_at, "must be after the start date")
      end
    end
  end
end
