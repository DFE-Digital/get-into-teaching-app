module TeachingEventsHelper
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
    event.type_id == GetIntoTeachingApiClient::Constants::EVENT_TYPES[type_name]
  end

  def event_type_name(id)
    GetIntoTeachingApiClient::Constants::EVENT_TYPES.invert[id]
  end
end
