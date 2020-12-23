require "rails_helper"

describe Events::EventBoxComponent, type: "component" do
  include_context "stub types api"
  let(:event) { build(:event_api) }

  subject! { render_inline(described_class.new(event)) }

  specify "renders an event box" do
    expect(page).to have_css(".event-box")
  end

  describe "heading" do
    specify "places the date and time in the datetime div" do
      page.find(".event-box__datetime") do |datetime_div|
        expect(datetime_div.native.inner_html).to include(
          "#{date_text} <br> #{start_at_text} - #{end_at_text}",
        )
      end
    end
  end

  describe "online/offline" do
    let(:online_heading) { "Online event" }
    let(:moved_online_heading) { "Event has moved online" }

    context "when the event is an online event type" do
      let(:event) { build(:event_api, :online_event) }

      specify "it's marked as being online" do
        expect(page).to have_css(".event-box__footer__meta", text: online_heading)
      end
    end

    context "when the event is online, with no associated building (not virtual)" do
      let(:event) { build(:event_api, :train_to_teach_event, :online) }

      specify "it's marked as being online" do
        expect(page).to have_css(".event-box__footer__meta", text: online_heading)
      end
    end

    context "when the event has moved online (virtual)" do
      let(:event) { build(:event_api, :train_to_teach_event, :virtual) }

      specify "it's marked as being moved online" do
        expect(page).to have_css(".event-box__footer__meta", text: moved_online_heading)
      end
    end

    context "when the event is offline" do
      let(:event) { build(:event_api, is_online: false) }

      specify "it's not marked as being online or moved online" do
        expect(page).not_to have_css(".event-box__footer__meta", text: online_heading)
        expect(page).not_to have_css(".event-box__footer__meta", text: moved_online_heading)
      end
    end
  end

  [
    OpenStruct.new(
      name: "Train to Teach event",
      trait: :train_to_teach_event,
      expected_colour: "purple",
      is_online: false,
      is_virtual: false,
    ),
    OpenStruct.new(
      name: "Online event",
      trait: :online_event,
      expected_colour: "blue",
      is_online: true,
      is_virtual: false,
    ),
    OpenStruct.new(
      name: "",
      trait: :no_event_type,
      expected_colour: "blue",
      is_online: false,
      is_virtual: false,
    ),
    # a 'Train to Teach event' that also happens to be online
    OpenStruct.new(
      name: "Train to Teach event",
      trait: :train_to_teach_event,
      expected_colour: "purple",
      is_online: true,
      is_virtual: true,
    ),
  ].each do |event_type|
    description = event_type.name.present? ? %(is a '#{event_type.name}') : %(isn't specified)

    context %(when the event #{description}) do
      let(:event) { build(:event_api, event_type.trait, is_online: event_type.is_online, is_virtual: event_type.is_virtual) }

      specify %(the event type name should be displayed) do
        expect(page).to have_content(event_type.name)
      end

      if event_type.is_online && event_type.trait == :online_event
        context "when is_online and an 'online_event'" do
          specify %(the event should also be described as an 'Online Event') do
            expect(page).to have_content("Online Event")
          end

          specify %(the online icon should be #{event_type.expected_colour}) do
            expect(page).to have_css(%(.icon-online-event--#{event_type.expected_colour}))
          end
        end
      end

      if event_type.is_online && event_type.trait != :online_event
        context "when is_online but not 'online_event'" do
          specify %(the event should also be described as a 'Event has moved online') do
            expect(page).to have_content("Event has moved online")
          end

          specify %(the online icon should be #{event_type.expected_colour}) do
            expect(page).to have_css(%(.icon-moved-online-event--#{event_type.expected_colour}))
          end
        end
      end

      specify %(the box should have the right type of divider) do
        if event_type.name.present?
          expect(page).to have_css(%(.event-box__divider.event-box__divider--#{event_type.name&.parameterize}))
        end
      end
    end
  end

  def date_text
    event.start_at.to_date.to_formatted_s(:long)
  end

  def start_at_text
    event.start_at.to_formatted_s(:time)
  end

  def end_at_text
    event.end_at.to_formatted_s(:time)
  end
end
