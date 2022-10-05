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
    future_dated? && (open? || closed?)
  end

  def accepts_online_registration?
    type_ids = [EventType.get_into_teaching_event_id]

    event.type_id.in?(type_ids) && future_dated? && open? && event.web_feed_id.present?
  end

private

  def future_dated?
    event.start_at.to_date >= Time.zone.now.utc.to_date
  end
end
