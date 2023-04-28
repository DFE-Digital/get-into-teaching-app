module TeachingEventsHelper
  def is_a_get_into_teaching_event?(event)
    event.type_id.in?(Crm::EventType.lookup_by_names("Get Into Teaching event"))
  end

  def event_list_id(name)
    %(#{name.parameterize}-list)
  end

  def event_format(event)
    [].tap { |formats|
      formats << "in-person" if event.is_in_person
      formats << "online" if event.is_online || event.is_virtual
    }.to_sentence.capitalize.presence
  end

  def is_event_type?(event, type_name)
    event.type_id == Crm::EventType.lookup_by_name(type_name)
  end

  def add_online_events(params)
    params_with_online = params
      .fetch(:teaching_events_search, {})
      .permit!
      .to_h
      .deep_symbolize_keys
      .tap do |h|
        h[:online] ||= []
        h[:online] << true
      end

    { teaching_events_search: params_with_online }
  end

  # override:
  # * Online event               => Online forum
  # * School or University event => Training provider
  def event_type_name(id, overrides: { "DfE Online Q&A" => 222_750_008, "Training provider" => 222_750_009 })
    Crm::EventType::ALL.merge(overrides).invert[id]
  end
end
