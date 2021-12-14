module TeachingEventsHelper
  def is_a_train_to_teach_event?(event)
    event.type_id.in?(EventType.lookup_by_names("Train to Teach event", "Question Time"))
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
    event.type_id == EventType.lookup_by_name(type_name)
  end

  # override:
  # * Online event               => Online forum
  # * School or University event => Training provider
  def event_type_name(id, overrides: { "DfE Online Q&A" => 222_750_008, "Training provider" => 222_750_009 })
    EventType::ALL.merge(overrides).invert[id]
  end
end
