module TeachingEvents
  class EventPresenter
    attr_reader :event

    def initialize(event)
      @event = event
    end

    delegate(
      :name,
      :start_at,
      :end_at,
      :building,
      :is_online,
      :type_id,
      :readable_id,
      :message,
      :description,
      :is_in_person,
      :is_online,
      :providers_list,
      :scribble_id,
      to: :event
    )
  end
end
