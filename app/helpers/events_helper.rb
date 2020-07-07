module EventsHelper
  def format_event_date(event)
    return if event.startAt.blank?

    if event.startAt.to_date == event.endAt.to_date
      sprintf \
        "%{startdate} at %{starttime} - %{endtime}",
        startdate: event.startAt.to_date.to_formatted_s(:long),
        starttime: event.startAt.to_formatted_s(:time),
        endtime: event.endAt.to_formatted_s(:time)
    else
      sprintf \
        "%{startdate} to %{enddate}",
        startdate: event.startAt.to_formatted_s(:full),
        enddate: event.endAt.to_formatted_s(:full)
    end
  end
end
