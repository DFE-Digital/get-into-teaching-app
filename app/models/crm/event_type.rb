class Crm::EventType
  ALL =
    {
      "Get Into Teaching event" => 222_750_012,
      "Online event" => 222_750_008,
      "School or University event" => 222_750_009,
    }.freeze

  QUERY_PARAM_NAMES =
    {
      "git" => 222_750_012,       # Get Into Teaching event
      "onlineqa" => 222_750_008,  # Online event
      "provider" => 222_750_009,  # School or University event
    }.freeze

  attr_accessor :type_id

  delegate(
    :lookup_by_id,
    :online_event_id,
    :school_or_university_event_id,
    :get_into_teaching_event_id,
    to: :class,
  )

  class << self
    def school_or_university_event_id
      lookup_by_name("School or University event")
    end

    def get_into_teaching_event_id
      lookup_by_name("Get Into Teaching event")
    end

    def online_event_id
      lookup_by_name("Online event")
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

    def lookup_by_query_param(name)
      QUERY_PARAM_NAMES.fetch(name)
    end

    def lookup_by_query_params(*names)
      QUERY_PARAM_NAMES.values_at(*names).compact
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

  def get_into_teaching_event?
    type_id == get_into_teaching_event_id
  end
end
