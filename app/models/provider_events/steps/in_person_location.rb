module ProviderEvents
  module Steps
    class InPersonLocation < ::GITWizard::Step
      LOCATION_OPTIONS = [EXISTING = "existing".freeze, NEW = "new".freeze].freeze

      include FunnelTitle

      attribute :location_option
      attribute :building

      validates :location_option, presence: true, inclusion: LOCATION_OPTIONS
      validates :building, presence: true, if: -> { existing? }

      def skipped?
        other_step(:event_type).online?
      end

      def location_options
        @location_options ||= LOCATION_OPTIONS.map { |id| OpenStruct.new(id: id) }
      end

      def buildings
        @buildings ||= GetIntoTeachingApiClient::TeachingEventBuildingsApi.new.get_teaching_event_buildings
      end

      def existing?
        location_option == EXISTING
      end

      def new?
        location_option == NEW
      end
    end
  end
end
