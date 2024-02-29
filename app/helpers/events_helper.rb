module EventsHelper
  include TextFormattingHelper

  def show_events_teaching_logo(index, type_id)
    index.zero? && type_id != Crm::EventType.school_or_university_event_id
  end

  def format_event_date(event, stacked: true)
    return if event.start_at.blank?

    if event.start_at.to_date == event.end_at.to_date
      safe_html_format(
        sprintf(
          "%{startdate} #{stacked ? '<br>' : 'at'} %{starttime} to %{endtime}",
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

  def can_sign_up_online?(event)
    Crm::EventStatus.new(event).accepts_online_registration?
  end

  def formatted_event_description(description)
    if strip_tags(description) != description
      safe_html_format(description)
    else
      safe_format(description)
    end
  end

  def display_event_provider_info?(event)
    !event.type_id.in?([git_event_type_id])
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
    when git_event_type_id
      "purple"
    else
      "blue"
    end
  end

  def categorise_events(events, params)
    events.map do |event|
      address = if event.building.present?
                  "#{event.building.venue}, #{event.building.address_city}"
                else
                  "Online event"
                end

      description = tag.div do
        safe_join([
          tag.div(address),
          tag.p(tag.strong(event.start_at.to_formatted_s(:event))),
        ])
      end

      OpenStruct.new(
        title: Crm::EventRegion.lookup_by_id(event.region_id),
        description: description,
        path: event_path(event.readable_id, channel: params[:channel], sub_channel: params[:sub_channel]),
      )
    end
  end

  def pluralised_category_name(type_id)
    t("event_types.#{type_id}.name.plural")
  end

  def display_no_git_events_message?(performed_search, events, event_search_type)
    get_into_teaching_id = git_event_type_id
    searching_for_git = get_into_teaching_id.to_s == event_search_type
    searching_for_all = event_search_type.blank?

    no_git_events = events.map(&:first).exclude?(get_into_teaching_id)

    performed_search && (searching_for_git || searching_for_all) && no_git_events
  end

  # Determines if the "see all events" button should
  # be shown in the events blocks or not.
  #
  # Currently the button needs to be hidden only in
  # the GIT block and when the are no GIT events.
  def show_see_all_events_button?(type_id, events)
    events.present? || type_id != git_event_type_id
  end

  def git_event_type_id
    Crm::EventType.get_into_teaching_event_id
  end
end
