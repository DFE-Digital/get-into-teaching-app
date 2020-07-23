module EventsHelper
  def format_event_date(event)
    return if event.start_at.blank?

    if event.start_at.to_date == event.end_at.to_date
      sprintf \
        "%{startdate} at %{starttime} - %{endtime}",
        startdate: event.start_at.to_date.to_formatted_s(:long),
        starttime: event.start_at.to_formatted_s(:time),
        endtime: event.end_at.to_formatted_s(:time)
    else
      sprintf \
        "%{startdate} to %{enddate}",
        startdate: event.start_at.to_formatted_s(:full),
        enddate: event.end_at.to_formatted_s(:full)
    end
  end
end
