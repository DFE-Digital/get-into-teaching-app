require "rails_helper"
require_relative "shared_event_box_examples"

describe Events::EventBoxComponent, type: "component" do
  include_context "stub types api"
  let(:event) { build(:event_api) }

  subject! { render_inline(Events::EventBoxComponent.new(event)) }

  specify "renders an event result box" do
    expect(page).to have_css(".event-resultbox")
  end

  specify "places the date and time in the datetime div" do
    page.find(".event-resultbox__datetime") do |datetime_div|
      expect(datetime_div).to have_content(event.start_at.to_date.to_formatted_s(:long_ordinal))
      expect(datetime_div).to have_content(event.start_at.to_formatted_s(:time))
      expect(datetime_div).to have_content(event.end_at.to_formatted_s(:time))
    end
  end

  specify "places the description in the content div" do
    page.find(".event-resultbox__content") do |content_div|
      expect(content_div).to have_content(event.summary)
    end
  end

  describe "online/offline" do
    let(:online_heading) { "Online Event" }
    context "when the event is online" do
      let(:event) { build(:event_api, is_online: true) }

      specify %(it's marked as being online) do
        expect(page).to have_css("h5", text: online_heading)
      end
    end

    context "when the event is offline" do
      let(:event) { build(:event_api, is_online: false) }

      specify %(it's not marked as being online) do
        expect(page).not_to have_css("h5", text: online_heading)
      end
    end
  end

  describe "location" do
    context "when the event has a location" do
      specify "the city should be displayed" do
        expect(page).to have_css(".event-resultbox__content__location")
        expect(page).to have_css("p", text: event.building.address_city)
      end
    end

    context "when the event has no location" do
      let(:event) { build(:event_api, :no_location) }

      specify "no location information should be displayed" do
        expect(page).not_to have_css(".event-resultbox__content__location")
      end
    end
  end

  it_behaves_like "an event box with an event type and coloured icons"
end
