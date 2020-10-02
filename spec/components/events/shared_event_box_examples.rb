shared_examples %(an event box with an event type and coloured icons) do
  [
    OpenStruct.new(name: "Application Workshop", trait: :application_workshop, expected_colour: "yellow"),
    OpenStruct.new(name: "Train to Teach Event", trait: :train_to_teach_event, expected_colour: "green"),
    OpenStruct.new(name: "Online Event", trait: :online_event, expected_colour: "purple"),
    OpenStruct.new(name: "", trait: :no_event_type, expected_colour: "blue"),
  ].each do |event_type|
    description = event_type.name.present? ? %(is a '#{event_type.name}') : %(isn't specified)

    context %(when the event #{description}) do
      let(:event) { build(:event_api, event_type.trait, is_online: true) }

      specify %(the event type name should be displayed) do
        expect(page).to have_content(event_type.name)
      end

      specify %(the box should have the right type of divider) do
        if event_type.name.present?
          expect(page).to have_css(%(.event-resultbox__divider.event-resultbox__divider--#{event_type.name&.parameterize}))
        end
      end

      specify %(the online icon should be #{event_type.expected_colour}) do
        expect(page).to have_css(%(.icon-online-event--#{event_type.expected_colour}))
      end

      specify %(the map pin icon should be #{event_type.expected_colour}) do
        expect(page).to have_css(%(.icon-pin--#{event_type.expected_colour}))
      end
    end
  end
end
