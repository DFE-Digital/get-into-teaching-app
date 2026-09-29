module CoerceToLondonTime
  def coerce_to_london_time(time)
    # NB: although the CRM may claim that a time is UTC; it isn't and is instead actually a London-local time. For example,
    # 9am on the 23 September (inside daylight saving) is incorrectly presented by the CRM as "2026-09-23T09:00:00Z".
    # Whereas 9am on 23 December (outside daylight saving) is correctly presented by the CRM as "2026-12-23T09:00:00Z".
    # In order to accommodate this behaviour, we ignore the timezone and assume the CRM time is always London-local to the date.

    london_time_zone.local(*time.deconstruct_keys(%i[year month day hour min sec]).values) if time.present?
  end

  def london_time_zone
    @london_time_zone ||= ActiveSupport::TimeZone["Europe/London"]
  end
end
