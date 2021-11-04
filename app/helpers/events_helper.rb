module EventsHelper
  include TextFormattingHelper

  def show_events_teaching_logo(index, type_id)
    index.zero? && type_id != GetIntoTeachingApiClient::Constants::EVENT_TYPES["School or University event"]
  end

  def format_event_date(event, stacked: true)
    return if event.start_at.blank?

    if event.start_at.to_date == event.end_at.to_date
      safe_html_format(
        sprintf(
          "%{startdate} #{stacked ? '<br>' : 'at'} %{starttime} - %{endtime}",
          startdate: event.start_at.to_date.to_formatted_s(:long),
          starttime: event.start_at.to_formatted_s(:time),
          endtime: event.end_at.to_formatted_s(:time),
        ),
      )
    else
      sprintf \
        "%{startdate} to %{enddate}",
        startdate: event.start_at.to_formatted_s(:full),
        enddate: event.end_at.to_formatted_s(:full)
    end
  end

  def event_status_open?(event)
    event.status_id == GetIntoTeachingApiClient::Constants::EVENT_STATUS["Open"]
  end

  def event_status_pending?(event)
    event.status_id == GetIntoTeachingApiClient::Constants::EVENT_STATUS["Pending"]
  end

  def can_sign_up_online?(event)
    event.web_feed_id && event_status_open?(event) && !is_event_type?(event, "School or University event")
  end

  def is_event_type?(event, type_name)
    event.type_id == GetIntoTeachingApiClient::Constants::EVENT_TYPES[type_name]
  end

  def event_type_name(id)
    GetIntoTeachingApiClient::Constants::EVENT_TYPES.invert[id]
  end

  def embed_event_video_url(video_url)
    video_url&.sub("watch?v=", "embed/")
  end

  def formatted_event_description(description)
    if strip_tags(description) != description
      safe_html_format(description)
    else
      safe_format(description)
    end
  end

  def display_event_provider_info?(event)
    !event.type_id.in?([qt_event_type_id, ttt_event_type_id])
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
    return building.address_city if event.is_online

    [
      building.address_line1,
      building.address_line2,
      building.address_line3,
      building.address_city,
      building.address_postcode,
    ].compact.join(",\n")
  end

  def event_location_map(event)
    address = event_address(event)

    ajax_map(
      address,
      zoom: 10,
      mapsize: [732, 490],
      title: event.name,
      description: address,
    )
  end

  def event_type_color(type_id)
    case type_id
    when ttt_event_type_id
      "purple"
    else
      "blue"
    end
  end

  def pluralised_category_name(type_id)
    t("event_types.#{type_id}.name.plural")
  end

  def past_category_name(type_id)
    t "event_types.#{type_id}.name.past",
      default: "Past " + pluralised_category_name(type_id)
  end

  def display_no_ttt_events_message?(performed_search, events, event_search_type)
    train_to_teach_id = ttt_event_type_id
    searching_for_ttt = train_to_teach_id.to_s == event_search_type
    searching_for_all = event_search_type.blank?

    no_ttt_events = events.map(&:first).exclude?(train_to_teach_id)

    performed_search && (searching_for_ttt || searching_for_all) && no_ttt_events
  end

  # Determines if the "see all events" button should
  # be shown in the events blocks or not.
  #
  # Currently the button needs to be hidden only in
  # the TTT block and when the are no TTT events.
  def show_see_all_events_button?(type_id, events)
    events.present? || type_id != ttt_event_type_id
  end

  def ttt_event_type_id
    GetIntoTeachingApiClient::Constants::EVENT_TYPES["Train to Teach event"]
  end

  def qt_event_type_id
    GetIntoTeachingApiClient::Constants::EVENT_TYPES["Question Time"]
  end

  def event_list_id(name)
    name.parameterize + "-list"
  end

  def format(event)
    [].tap do |formats|
      formats << "in-person" if event.is_in_person
      formats << "online" if event.is_in_person || event.is_virtual
    end.to_sentence.capitalize
  end
end
