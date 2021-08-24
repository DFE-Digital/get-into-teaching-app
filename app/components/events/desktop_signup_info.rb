module Events
  class DesktopSignupInfo < EventBoxComponent
    def divider_thin
      event_type_divider_class = %(event-box__divider--#{type_name.parameterize})

      tag.hr(class: (%w[event-box__divider thin] << event_type_divider_class).compact)
    end
  end
end
