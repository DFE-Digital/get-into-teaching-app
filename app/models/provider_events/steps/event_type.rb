module ProviderEvents
  module Steps
    class EventType < ::GITWizard::Step
      EVENT_TYPES = [IN_PERSON = "in_person".freeze, ONLINE = "online".freeze].freeze

      include FunnelTitle

      attribute :event_type

      validates :event_type, presence: true, inclusion: EVENT_TYPES

      def event_types
        @event_types ||= EVENT_TYPES.map { |id| OpenStruct.new(id: id) }
      end

      def in_person?
        event_type == IN_PERSON
      end

      def online?
        event_type == ONLINE
      end
    end
  end
end
