module EventsHelper
  def format_event_date(event)
    return if event.startDate.blank?

    if event.startDate == event.endDate
      event.startDate.to_formatted_s(:long)
    else
      sprintf \
        "%{startdate} to %{enddate}",
        startdate: event.startDate.to_formatted_s(:long),
        enddate: event.endDate.to_formatted_s(:long)
    end
  end
end
