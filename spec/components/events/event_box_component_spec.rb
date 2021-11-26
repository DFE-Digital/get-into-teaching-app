require "rails_helper"

describe Events::EventBoxComponent, type: "component" do
  include_context "with stubbed types api"
  subject! { render_inline(described_class.new(event)) }

  let(:event) { build(:event_api) }
  let(:date_text) { event.start_at.to_date.to_formatted_s(:long) }
  let(:start_at_text) { event.start_at.to_formatted_s(:time) }
  let(:end_at_text) { event.end_at.to_formatted_s(:time) }

  specify "renders an event box" do
    expect(page).to have_css(".event-box")
  end

  describe "heading" do
    specify "places the date and time in the datetime div" do
      page.find(".event-box__datetime") do |datetime_div|
        expect(datetime_div.native.inner_html).to include(
          "#{date_text} <br> #{start_at_text} to #{end_at_text}",
        )
      end
    end
  end

  describe "online/offline" do
    let(:online_heading) { "Online event" }
    let(:moved_online_heading) { "Online event" }

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

  context "with Train to Teach category offline event" do
    let(:event) { build :event_api, :train_to_teach_event }

    specify %(the event type name should be displayed) do
      expect(page).to have_content("Train to Teach event")
    end

    specify %(the box should have the right type of divider) do
      expect(page).to have_css(%(.event-box__divider.event-box__divider--train-to-teach-event))
    end
  end

  context "with Online event category event" do
    let(:event) { build :event_api, :online_event }

    specify %(the event type name should not be displayed) do
      expect(page).to have_css("footer .event-box__footer__item", count: 1)
    end

    specify %(the event should also be described as an 'Online event') do
      expect(page).to have_content("Online event")
    end

    specify %(the online icon should be blue) do
      expect(page).to have_css(%(.icon-online-event--blue))
    end

    specify %(the box should have the right type of divider) do
      expect(page).to have_css(%(.event-box__divider.event-box__divider--online-q-a))
    end
  end

  context "with Train to Teach category online event" do
    let(:event) { build :event_api, :train_to_teach_event, :virtual }

    specify %(the event type name should be displayed) do
      expect(page).to have_content("Train to Teach event")
    end

    specify %(the event should also be described as a 'Event has moved online') do
      expect(page).to have_content("Online event")
    end

    specify %(the online icon should be purple) do
      expect(page).to have_css(%(.icon-moved-online-event--purple))
    end

    specify %(the box should have the right type of divider) do
      expect(page).to have_css(%(.event-box__divider.event-box__divider--train-to-teach-event))
    end
  end
end
