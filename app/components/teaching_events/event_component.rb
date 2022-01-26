module TeachingEvents
  class EventComponent < ViewComponent::Base
    attr_reader :title, :type, :slug

    def initialize(event:)
      @event     = event
      @title     = event.name
      @type      = EventType.new(event)
      @online    = event.is_online
      @in_person = event.building.present?
      @start_at  = event.start_at
      @end_at    = event.end_at
      @slug      = event.readable_id

      super
    end

    delegate :provider_event?, to: :type

    def train_to_teach?
      type.train_to_teach_or_question_time_event?
    end

    def online?
      @online
    end

    def in_person?
      @in_person && !online?
    end

    def event_type
      helpers.event_type_name(type.type_id)
    end

    def location
      @event&.building&.address_city
    end

    def date
      @start_at.to_formatted_s(:event)
    end

    def times
      safe_join([@start_at.to_formatted_s(:time), @end_at.to_formatted_s(:time)], "&ndash;".html_safe)
    end

    def classes
      class_names(
        "event",
        "event--train-to-teach" => train_to_teach?,
        "event--regular" => !train_to_teach?,
        "event--training-provider" => provider_event?,
      )
    end
  end
end
