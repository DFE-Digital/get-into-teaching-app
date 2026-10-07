require "date"

module CoerceToLondonTime
  def coerce_to_london_time(value)
    # The CRM may incorrectly label London-local timestamps as UTC, so for
    # date/time labels we intentionally ignore any supplied timezone/offset.

    return if value.blank?

    case value
    when ActiveSupport::TimeWithZone, Time, DateTime
      london_local_time(
        value.year,
        value.month,
        value.day,
        value.hour,
        value.min,
        value.sec,
      )
    when Date
      # A Date has no time-of-day, so interpret it as midnight in London.
      london_local_time(value.year, value.month, value.day, 0, 0, 0)
    when String
      london_time_from_string(value)
    else
      raise ArgumentError,
            "Expected a Time, DateTime, Date, String; got #{value.class}"
    end
  end

  def london_time_zone
    @london_time_zone ||= ActiveSupport::TimeZone["Europe/London"]
  end

private

  def london_local_time(year, month, day, hour, minute, second)
    london_time_zone.local(year, month, day, hour, minute, second)
  end

  def london_time_from_string(value)
    parts = Date._iso8601(value)

    unless parts.values_at(:year, :mon, :mday).all?
      raise ArgumentError, "Invalid timestamp: #{value.inspect}"
    end

    london_local_time(
      parts[:year],
      parts[:mon],
      parts[:mday],
      parts.fetch(:hour, 0),
      parts.fetch(:min, 0),
      parts.fetch(:sec, 0),
    )
  end
end
