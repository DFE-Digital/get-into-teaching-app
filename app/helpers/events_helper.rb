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

  def embed_event_video_url(video_url)
    video_url&.sub("watch?v=", "embed/")
  end

  def event_has_provider_info?(event)
    event.provider_website_url ||
      event.provider_target_audience ||
      event.provider_organiser ||
      event.provider_contact_email
  end

  def event_address(event)
    building = event.building
    return nil unless building

    [
      building.address_line1,
      building.address_line2,
      building.address_line3,
      building.address_city,
      building.address_postcode,
    ].compact!.join(",\n")
  end

  def name_of_event_type(type_id)
    api = GetIntoTeachingApiClient::TypesApi.new
    type = api.get_teaching_event_types.find { |t| t.id == type_id.to_s }
    type&.value || ""
  end

  def event_type_color(type_id)
    case type_id
    when GetIntoTeachingApiClient::Constants::EVENT_TYPES["Application Workshop"]
      "yellow"
    when GetIntoTeachingApiClient::Constants::EVENT_TYPES["Train to Teach Event"]
      "green"
    when GetIntoTeachingApiClient::Constants::EVENT_TYPES["Online Event"]
      "purple"
    else
      "blue"
    end
  end
end
