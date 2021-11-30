class EventType
  attr_accessor :type_id

  delegate(
    :lookup_by_id,
    :online_event_id,
    :school_or_university_event_id,
    :train_to_teach_event_id,
    :question_time_event_id,
    to: :class,
  )

  class << self
    def school_or_university_event_id
      lookup_by_name("School or University event")
    end

    def train_to_teach_event_id
      lookup_by_name("Train to Teach event")
    end

    def online_event_id
      lookup_by_name("Online event")
    end

    def question_time_event_id
      lookup_by_name("Question Time")
    end

    def lookup_by_name(name)
      GetIntoTeachingApiClient::Constants::EVENT_TYPES.fetch(name)
    end

    def lookup_by_names(*names)
      GetIntoTeachingApiClient::Constants::EVENT_TYPES.values_at(*names)
    end

    def lookup_by_id(id)
      GetIntoTeachingApiClient::Constants::EVENT_TYPES.invert.fetch(id)
    end

    def lookup_by_ids(*ids)
      GetIntoTeachingApiClient::Constants::EVENT_TYPES.invert.values_at(*ids)
    end
  end

  def initialize(event)
    @event   = event
    @type_id = event.type_id
  end

  def type
    lookup_by_id(type_id)
  end

  # this name might be confusing...
  def online_event?
    type_id == online_event_id
  end

  def school_or_university_event?
    type_id == school_or_university_event_id
  end

  def question_time_event?
    type_id == question_time_event_id
  end

  def train_to_teach_event?
    type_id == train_to_teach_event_id
  end

  def train_to_teach_or_question_time_event?
    type_id.in?([train_to_teach_event_id, question_time_event_id])
  end
end
