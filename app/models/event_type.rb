class EventType
  ALL =
    {
      "Train to Teach event" => 222_750_001,
      "Question Time" => 222_750_007,
      "Online event" => 222_750_008,
      "School or University event" => 222_750_009,
    }.freeze

  WITH_ARCHIVE =
    {
      "Online event" => 222_750_008,
    }.freeze

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
      ALL.fetch(name)
    end

    def lookup_by_names(*names)
      ALL.fetch_values(*names)
    end

    def lookup_by_id(id)
      ALL.invert.fetch(id)
    end

    def lookup_by_ids(*ids)
      ALL.invert.fetch_values(*ids)
    end

    def has_archive?(id)
      WITH_ARCHIVE.values.include?(id)
    end

    def all_ids
      ALL.values
    end
  end

  def initialize(event)
    @event   = event
    @type_id = event.type_id
  end

  def type
    lookup_by_id(type_id)
  end

  def online_qa_event?
    type_id == online_event_id
  end

  def provider_event?
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
