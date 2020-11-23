module Events
  class EventBoxComponent < ViewComponent::Base
    attr_reader :title, :event, :type, :online, :condensed

    delegate :format_event_date, :name_of_event_type, :event_type_color, :safe_format, to: :helpers

    alias_method :condensed?, :condensed

    def initialize(event, condensed: false)
      @event       = event
      @title       = event.name
      @type        = event.type_id
      @online      = event.is_online
      @condensed   = condensed
    end

    def datetime
      format_event_date(event, stacked: true)
    end

    def type_name
      t("event_types.#{type}.name.singular")
    end

    def type_color
      event_type_color(type)
    end

    def online?
      online
    end

    def heading
      condensed ? datetime : title
    end

    def divider
      event_type_divider_class = %(event-box__divider--#{type_name.parameterize})

      tag.hr(class: (%w[event-box__divider] << event_type_divider_class).compact)
    end

    def event_type_icon
      icon_class = %(icon-#{type_name.parameterize})

      tag.div(class: [event_box_footer_icon_class, icon_class])
    end

    def online_icon
      icon_class = moved_online? ? "icon-moved-online-event" : "icon-online-event"
      colour_class = "#{icon_class}--#{type_color}"

      tag.div(class: [event_box_footer_icon_class, icon_class, colour_class])
    end

    def online_text
      return "Event has moved online" if moved_online?

      "Online Event"
    end

  private

    def moved_online?
      online? && !online_event_type?
    end

    def online_event_type?
      @type == GetIntoTeachingApiClient::Constants::EVENT_TYPES["Online Event"]
    end

    def event_box_footer_icon_class
      "event-box__footer__icon"
    end
  end
end
