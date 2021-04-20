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

    def self.initialize_with_api_event(api_event)
      hash = convert_attributes_from_api_model(api_event)
      new(hash).tap do |event|
        if api_event.building.present?
          event.building = EventBuilding.initialize_with_api_building(api_event.building)
          event.venue_type = VENUE_TYPES[:existing]
        else
          event.venue_type = VENUE_TYPES[:none]
        end
      end
    end

    def assign_building(building_params)
      id = building_params[:id]

      if venue_type == VENUE_TYPES[:existing] && id.present?
        api_building = buildings.find { |b| b.id == id }
        self.building = EventBuilding.initialize_with_api_building(api_building)
      elsif venue_type == VENUE_TYPES[:add]
        self.building = EventBuilding.new(building_params.except(:id))
      end
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

    def buildings
      @buildings ||= GetIntoTeachingApiClient::TeachingEventBuildingsApi
                       .new.get_teaching_event_buildings
    end

    def invalid?
      invalid_building = building.present? && building.invalid?
      super || invalid_building
    end

  private

    def map_api_errors_to_attributes(response)
      JSON.parse(response.response_body)["errors"].each do |key, value|
        errors.add(key.underscore.to_sym, value[0])
      end
    end

    def end_after_start
      return if end_at.blank? || start_at.blank?

      if end_at <= start_at
        errors.add(:end_at, "Must be after the start date")
      end
    end
  end
end
