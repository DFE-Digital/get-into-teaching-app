module Internal
  class Event
    include ActiveModel::Model
    include ActiveModel::Attributes

    VENUE_TYPES = { add: "add", existing: "existing", none: "none" }.freeze

    def self.initialize_with_api_event(event)
      hash = event.to_hash.transform_keys { |k| k.to_s.underscore }.filter { |k| Event.attribute_names.include?(k) }
      hash["start_at"] = format_time(hash["start_at"])
      hash["end_at"] = format_time(hash["end_at"])
      hash["building"] = transform_event_building(hash["building"]) unless hash["building"].nil?
      new(hash)
    end

    def self.transform_event_building(building)
      hash = building.transform_keys { |k| k.to_s.underscore }.filter { |k| EventBuilding.attribute_names.include?(k) }
      EventBuilding.new(hash)
    end

    attribute :id, :string, default: nil
    attribute :readable_id, :string
    attribute :status_id, :integer
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
    attribute :venue_type, VENUE_TYPES

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

    def persisted?
      id.present?
    end

    def submit_pending
      self.status_id = GetIntoTeachingApiClient::Constants::EVENT_STATUS["Pending"]
      submit
    end

    def approve
      self.status_id = GetIntoTeachingApiClient::Constants::EVENT_STATUS["Open"]
      submit
    end

    class << self
    private

      def format_time(attribute)
        Time.zone.parse(attribute.to_s)
      end
    end

  private

    def submit
      return false if invalid?

      submit_to_api?
    end

    def end_after_start
      return if end_at.blank? || start_at.blank?

      if end_at.floor <= start_at.floor
        errors.add(:end_at, "must be after the start date")
      end
    end

    def submit_to_api?
      body = GetIntoTeachingApiClient::TeachingEvent.new(
        id: id.presence,
        name: name,
        readableId: readable_id,
        typeId: GetIntoTeachingApiClient::Constants::EVENT_TYPES["School or University event"],
        statusId: status_id,
        summary: summary,
        description: description,
        isOnline: is_online,
        startAt: start_at,
        endAt: end_at,
        providerContactEmail: provider_contact_email,
        providerOrganiser: provider_organiser,
        providerTargetAudience: provider_target_audience,
        providerWebsiteUrl: provider_website_url,
      )

      if building.present?
        body.building = GetIntoTeachingApiClient::TeachingEventBuilding.new(
          venue: building.venue.presence,
          addressLine1: building.address_line1.presence,
          addressLine2: building.address_line2.presence,
          addressLine3: building.address_line3.presence,
          addressCity: building.address_city.presence,
          addressPostcode: building.address_postcode.presence,
          id: building.id.presence,
        )
      end

      begin
        GetIntoTeachingApiClient::TeachingEventsApi.new.upsert_teaching_event(body)

        true
      rescue GetIntoTeachingApiClient::ApiError => e
        map_errors_to_fields(e) if e.code == 400
        false
      end
    end

    def map_errors_to_fields(error)
      JSON.parse(error.response_body)["errors"].each do |key, value|
        errors.add(key.underscore.to_sym, value[0])
      end
    end
  end
end
