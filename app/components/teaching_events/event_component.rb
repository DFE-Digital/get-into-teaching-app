module TeachingEvents
  class EventComponent < ViewComponent::Base
    attr_reader :title, :type, :slug

    def initialize(event:)
      @event    = event
      @title    = event.name
      @type     = event.type_id
      @online   = event.is_online
      @virtual  = event.is_virtual
      @start_at = event.start_at
      @end_at   = event.end_at
      @slug     = event.readable_id

      super
    end

    # check if event is 'train to teach' or 'question time'
    def train_to_teach?
      type.in?([222_750_001, 222_750_007])
    end

    def school_and_university?
      type == 222_750_009
    end

    def setting
      if @online || @virtual
        "Online"
      else
        "In person"
      end
    end

    def setting_classes
      if @online || @virtual
        "online"
      else
        "in-person"
      end
    end

    def event_type
      helpers.event_type_name(type)
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
      )
    end
  end
end
