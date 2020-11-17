require "rails_helper"

describe Events::EventBoxComponent, type: "component" do
  include_context "stub types api"
  let(:event) { build(:event_api) }
  let(:condensed) { false }

  subject! { render_inline(Events::EventBoxComponent.new(event, condensed: condensed)) }

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

    context "when condensed" do
      let(:condensed) { true }

      specify "does not display the event name" do
        expect(page).not_to have_content(event.name)
      end
    end
  end

  describe "event description" do
    specify "places the description in the content div" do
      page.find(".event-box__content") do |content_div|
        expect(content_div).to have_content(event.summary)
      end
    end

    context "when the event is a virtual TTT event" do
      let(:event) { build(:event_api, :virtual_train_to_teach_event) }

      specify { expect(page).to_not have_selector(".event-box__content") }
    end

    context "when condensed" do
      let(:condensed) { true }

      specify { expect(page).to_not have_selector(".event-box__content") }
    end
  end

  describe "online/offline" do
    let(:online_heading) { "Online Event" }
    context "when the event is online" do
      let(:event) { build(:event_api, is_online: true) }

      specify %(it's marked as being online) do
        expect(page).to have_css(".event-box__footer__meta", text: online_heading)
      end
    end

    context "when the event is offline" do
      let(:event) { build(:event_api, is_online: false) }

      specify %(it's not marked as being online) do
        expect(page).not_to have_css(".event-box__footer__meta", text: online_heading)
      end
    end
  end

  describe "location" do
    let(:location_description_div) { ".event-box__footer__meta--location" }
    context "when the event has a location" do
      specify "the city should be displayed" do
        expect(page).to have_css(location_description_div, text: event.building.address_city)
      end
    end

    context "when the event has no location" do
      let(:event) { build(:event_api, :no_location) }

      specify "no location information should be displayed" do
        expect(page).not_to have_css(location_description_div)
      end
    end
  end

  [
    OpenStruct.new(
      name: "Train to Teach Event",
      trait: :train_to_teach_event,
      expected_colour: "green",
      is_online: false,
    ),
    OpenStruct.new(
      name: "Online Event",
      trait: :online_event,
      expected_colour: "purple",
      is_online: true,
    ),
    OpenStruct.new(
      name: "",
      trait: :no_event_type,
      expected_colour: "blue",
      is_online: false,
    ),
    # a 'Train to Teach Event' that also happens to be online
    OpenStruct.new(
      name: "Train to Teach Event",
      trait: :train_to_teach_event,
      expected_colour: "green",
      is_online: true,
    ),
  ].each do |event_type|
    description = event_type.name.present? ? %(is a '#{event_type.name}') : %(isn't specified)

    context %(when the event #{description}) do
      let(:event) { build(:event_api, event_type.trait, is_online: event_type.is_online) }

      specify %(the event type name should be displayed) do
        expect(page).to have_content(event_type.name)
      end

      if event_type.is_online && event_type.trait != :online_event
        specify %(the event should also be described as an 'Online Event') do
          expect(page).to have_content("Online Event")
        end
      end

      specify %(the box should have the right type of divider) do
        if event_type.name.present?
          expect(page).to have_css(%(.event-box__divider.event-box__divider--#{event_type.name&.parameterize}))
        end
      end

      if event_type.is_online
        specify %(the online icon should be #{event_type.expected_colour}) do
          expect(page).to have_css(%(.icon-online-event--#{event_type.expected_colour}))
        end
      end

      specify %(the map pin icon should be #{event_type.expected_colour}) do
        expect(page).to have_css(%(.icon-pin--#{event_type.expected_colour}))
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
