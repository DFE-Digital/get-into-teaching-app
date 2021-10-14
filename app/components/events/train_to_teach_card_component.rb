module Events
  class TrainToTeachCardComponent < ViewComponent::Base
    with_collection_parameter :event

    attr_reader :title, :type

    def initialize(event:)
      @event       = event
      @title       = event.name
      @type        = event.type_id
      @online      = event.is_online
      @virtual     = event.is_virtual

      super
    end

    def setting
      if @online || @virtual
        "Online"
      else
        "In person"
      end
    end

    def location
      "TODO"
    end

    def date
      "TODO"
    end

    def time_and_duration
      "TODO"
    end

    def train_to_teach?
      type == GetIntoTeachingApiClient::Constants::EVENT_TYPES["Train to Teach event"]
    end

    def train_to_teach_class
      "train-to-teach" if train_to_teach?
    end
  end
end
