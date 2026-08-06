module ProviderEvents
  module Steps
    class InPersonLocation < ::GITWizard::Step
      LOCATION_OPTIONS = [EXISTING = "existing".freeze, NEW = "new".freeze].freeze

      include FunnelTitle

      attribute :location_option
      attribute :building

      validates :location_option, presence: true, inclusion: LOCATION_OPTIONS
      validates :building, presence: true, if: -> { existing? }

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

    private

      def location_option_inquiry = location_option.to_s.inquiry
    end
  end
end
