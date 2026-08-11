module ProviderEvents
  module Steps
    class InPersonLocation < ::GITWizard::Step
      LOCATION_OPTIONS = [EXISTING = "existing".freeze, NEW = "new".freeze].freeze

      include FunnelTitle

      attribute :location_option
      attribute :building_id

      validates :location_option, presence: true, inclusion: LOCATION_OPTIONS
      validates :building_id, presence: true, if: -> { existing? }

      delegate :existing?, :new?, to: :location_option_inquiry

      LocationOptionData = Data.define(:id, :value)

      def skipped?
        other_step(:event_type).online?
      end

      def location_options
        @location_options ||= LOCATION_OPTIONS.map { |id| LocationOptionData.new(id: id, value: id) }
      end

      def buildings
        @buildings ||= GetIntoTeachingApiClient::TeachingEventBuildingsApi.new.get_teaching_event_buildings
      end

      def reviewable_answers
        if existing?
          { "venue" => building_record.present? ? "#{building_record.venue} (#{building_record&.address_postcode})" : nil }
        end
      end

    private

      def building_record
        @building_record ||= buildings.find { |b| b.id == building_id } if building_id.present?
      end

      def location_option_inquiry = location_option.to_s.inquiry
    end
  end
end
