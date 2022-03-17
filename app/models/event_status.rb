class EventStatus
  ALL =
    {
      "Open" => 222_750_000,
      "Closed" => 222_750_001,
      "Pending" => 222_750_003,
    }.freeze

  attr_accessor :event

  delegate(
    :pending_id,
    :closed_id,
    :open_id,
    to: :class,
  )

  class << self
    def pending_id
      ALL["Pending"]
    end

    def closed_id
      ALL["Closed"]
    end

    def open_id
      ALL["Open"]
    end
  end

  def initialize(event)
    @event = event
  end

  def closed?
    event.status_id == closed_id
  end

  def pending?
    event.status_id == pending_id
  end

  def open?
    event.status_id == open_id
  end

  def viewable?
    !pending? && future_dated?
  end

  def accepts_online_registration?
    type_ids = [EventType.question_time_event_id, EventType.train_to_teach_event_id]

    event.type_id.in?(type_ids) && future_dated? && open?
  end

private

  def future_dated?
    event.start_at.to_date >= Time.zone.now.utc.to_date
  end
end
