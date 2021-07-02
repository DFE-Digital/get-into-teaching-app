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
    attribute :is_online, :boolean, default: nil
    attribute :start_at, :datetime
    attribute :end_at, :datetime
    attribute :provider_contact_email, :string, default: nil
    attribute :provider_organiser, :string, default: nil
    attribute :provider_target_audience, :string, default: nil
    attribute :provider_website_url, :string, default: nil
    attribute :scribble_id, :string, default: nil
    attribute :building
    attribute :venue_type, default: VENUE_TYPES[:none]

    validates :name, presence: true, allow_blank: false, length: { maximum: 300 }
    validates :readable_id, presence: true, allow_blank: false, length: { maximum: 300 }
    validates :summary, presence: true, allow_blank: false, length: { maximum: 1000 }
    validates :description, presence: true, allow_blank: false, length: { maximum: 2000 }
    validates :is_online, inclusion: { in: [true, false] }, if: -> { provider_event? }
    validates :start_at, presence: true, allow_blank: false
    validates :end_at, presence: true
    validates :provider_contact_email,
              presence: true,
              allow_blank: false,
              email_format: true,
              length: { maximum: 100 }, if: -> { provider_event? }
    validates :provider_organiser, presence: true, allow_blank: false, length: { maximum: 300 }, if: -> { provider_event? }
    validates :provider_target_audience, presence: true, allow_blank: false, length: { maximum: 500 }, if: -> { provider_event? }
    validates :provider_website_url, presence: true, allow_blank: false, length: { maximum: 300 }, if: -> { provider_event? }
    validates :scribble_id, presence: true, allow_blank: false, length: { maximum: 300 }, if: -> { online_event? }
    validates :venue_type, inclusion: { in: VENUE_TYPES.values }
    validate :dates_in_future
    validate :end_after_start
    validate :existing_building_present

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
      if e.code == 400
        map_api_errors_to_attributes(e)
        false
      else
        raise
      end
    end

    def buildings
      @buildings ||= GetIntoTeachingApiClient::TeachingEventBuildingsApi
                       .new.get_teaching_event_buildings
    end

    def type_id=(value)
      super(value)

      self.is_online = true if online_event?
    end

    def invalid?
      invalid_building = building.present? && building.invalid?
      super || invalid_building
    end

    def provider_event?
      type_id == GetIntoTeachingApiClient::Constants::EVENT_TYPES["School or University event"]
    end

    def online_event?
      type_id == GetIntoTeachingApiClient::Constants::EVENT_TYPES["Online event"]
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

    def dates_in_future
      date_attributes = %i[start_at end_at]

      date_attributes.each do |attribute_name|
        attribute_value = send(attribute_name)
        if attribute_value.present? && attribute_value <= Time.zone.now
          errors.add(attribute_name, "Must be in the future")
        end
      end
    end

    def existing_building_present
      if venue_type == VENUE_TYPES[:existing] && building&.id.nil?
        errors.add(:venue_type, "You must select an existing building")
      end
    end
  end
end
