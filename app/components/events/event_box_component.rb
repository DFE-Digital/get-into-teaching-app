module Events
  class EventBoxComponent < ViewComponent::Base
    attr_reader :title, :event, :description, :type, :online, :location, :condensed

    delegate :format_event_date, :name_of_event_type, :event_type_color, :safe_format, to: :helpers

    alias_method :condensed?, :condensed

    def initialize(event, condensed: false)
      @event       = event
      @title       = event.name
      @description = event.summary
      @type        = event.type_id
      @online      = event.is_online
      @location    = event.building&.address_city
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

    def description_hidden?
      condensed? || virtual_train_to_teach_event?
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
      colour_class = %(icon-online-event--#{type_color})

      tag.div(class: [event_box_footer_icon_class, "icon-online-event", colour_class])
    end

    def location_icon
      colour_class = %(icon-pin--#{type_color})

      tag.div(class: [event_box_footer_icon_class, "icon-pin", colour_class])
    end

  private

    def virtual_train_to_teach_event?
      online? && train_to_teach_event?
    end

    def train_to_teach_event?
      @type == GetIntoTeachingApiClient::Constants::EVENT_TYPES["Train to Teach Event"]
    end

    def event_box_footer_icon_class
      "event-box__footer__icon"
    end
  end
end
