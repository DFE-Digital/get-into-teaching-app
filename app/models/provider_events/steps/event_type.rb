module ProviderEvents
  module Steps
    class EventType < ::GITWizard::Step
      EVENT_TYPES = [IN_PERSON = "in_person".freeze, ONLINE = "online".freeze].freeze

      include FunnelTitle

      attribute :event_type

      validates :event_type, presence: true, inclusion: EVENT_TYPES

      delegate :in_person?, :online?, to: :event_type_inquiry

      EventTypeData = Data.define(:id, :value)

      def event_types
        @event_types ||= EVENT_TYPES.map { |id| EventTypeData.new(id: id, value: id) }
      end

      def reviewable_answers
        { "event_type" => event_type ? I18n.t("helpers.answer.provider_events_steps.event_type.event_type.#{event_type}") : nil }
      end

    private

      def event_type_inquiry = event_type.to_s.inquiry
    end
  end
end
