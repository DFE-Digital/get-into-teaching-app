module EventsHelper
  def format_event_date(event, stacked: true)
    return if event.start_at.blank?

    if event.start_at.to_date == event.end_at.to_date
      sprintf(
        "%{startdate} #{stacked ? '<br />' : 'at'} %{starttime} - %{endtime}",
        startdate: event.start_at.to_date.to_formatted_s(:long_ordinal),
        starttime: event.start_at.to_formatted_s(:time),
        endtime: event.end_at.to_formatted_s(:time),
      ).html_safe
    else
      sprintf \
        "%{startdate} to %{enddate}",
        startdate: event.start_at.to_formatted_s(:long_ordinal),
        enddate: event.end_at.to_formatted_s(:long_ordinal)
    end
  end

  def name_of_event_type(type_id)
    api = GetIntoTeachingApiClient::TypesApi.new
    type = api.get_teaching_event_types.find { |t| t.id == type_id.to_s }
    type&.value || ""
  end

  def train_to_teach_event_type?(type_id)
    GetIntoTeachingApiClient::Constants::EVENT_TYPES["Train to Teach event"] == type_id
  end
end
