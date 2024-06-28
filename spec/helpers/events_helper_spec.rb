require "rails_helper"

describe EventsHelper, type: "helper" do
  include MapsHelper

  let(:startdate) { Time.zone.local(2020, 6, 1, 10) }
  let(:enddate) { Time.zone.local(2020, 6, 1, 12) }
  let(:event) { build(:event_api, start_at: startdate, end_at: enddate) }
  let(:building_fully_populated) { build(:event_building_api, address_line3: "Line 3") }

  describe "#show_events_teaching_logo" do
    it "returns false if the index != 0" do
      show_logo = show_events_teaching_logo(1, Crm::EventType.get_into_teaching_event_id)
      expect(show_logo).to be_falsy
    end

    it "returns false if the type_id is School or University event" do
      show_logo = show_events_teaching_logo(0, Crm::EventType.school_or_university_event_id)
      expect(show_logo).to be_falsy
    end

    it "returns true if the index is 0 and the type_id is not School or University event" do
      show_logo = show_events_teaching_logo(0, Crm::EventType.get_into_teaching_event_id)
      expect(show_logo).to be_truthy

      show_logo = show_events_teaching_logo(0, Crm::EventType.online_event_id)
      expect(show_logo).to be_truthy
    end
  end

  describe "#format_event_date" do
    subject { format_event_date event, stacked: stacked }

    let(:stacked) { true }

    context "with a single day event" do
      it { is_expected.to eql "1 June 2020 <br> 10:00 to 12:00" }
    end

    context "with a multi day event" do
      let(:enddate) { Time.zone.local(2020, 6, 4, 14) }

      it { is_expected.to eql "1 June 2020 10:00 to 4 June 2020 14:00" }
    end

    context "when not stacked" do
      let(:stacked) { false }

      it { is_expected.to eql "1 June 2020 at 10:00 to 12:00" }
    end
  end

  describe "#formatted_event_description" do
    subject { formatted_event_description(description) }

    context "when plain text" do
      let(:description) { "Some\nText" }

      it { is_expected.to eq("<p>Some\n<br />Text</p>") }
    end

    context "when HTML" do
      let(:description) { "<p>Some <b>text</b></p>" }

      it { is_expected.to eq("<p>Some <b>text</b></p>") }
    end
  end

  describe "#event_location_map" do
    subject { event_location_map(event) }

    before do
      allow(Rails.application.config.x).to receive(:google_maps_key).and_return("12345")
    end

    it { is_expected.to match(/data-map-description="Line 1,\nLine 2,\nManchester,\nMA1 1AM" /) }
    it { is_expected.to match(/zoom=10/) }
    it { is_expected.to match(/alt="Map showing #{event.name}"/) }
  end

  describe "#can_sign_up_online?" do
    subject { can_sign_up_online?(event) }

    context "when GIT (with web feed id), future-dated, open" do
      let(:event) { build(:event_api, :get_into_teaching_event) }

      it { is_expected.to be_truthy }
    end

    context "when not GIT, future-dated, open" do
      let(:event) { build(:event_api, :online_event) }

      it { is_expected.to be_falsy }
    end

    context "when GIT (with web feed id), past, open" do
      let(:event) { build(:event_api, :get_into_teaching_event, :past) }

      it { is_expected.to be_falsy }
    end

    context "when GIT (with web feed id), future-dated, closed" do
      let(:event) { build(:event_api, :get_into_teaching_event, :closed) }

      it { is_expected.to be_falsy }
    end

    context "when GIT (without web feed id), future-dated, open" do
      let(:event) { build(:event_api, :get_into_teaching_event, web_feed_id: nil) }

      it { is_expected.to be_falsy }
    end
  end

  describe "#event_type_color" do
    it "returns purple for get into teaching events" do
      expect(event_type_color(Crm::EventType.get_into_teaching_event_id)).to eq("purple")
    end

    it "returns blue for non-get into teaching events" do
      expect(event_type_color(Crm::EventType.online_event_id)).to eq("blue")
      expect(event_type_color(Crm::EventType.school_or_university_event_id)).to eq("blue")
    end
  end

  describe "#event_address" do
    it "returns nil if the event has no building" do
      event.building = nil
      expect(event_address(event)).to be_nil
    end

    it "returns only the address_city if the event is online" do
      event.is_online = true
      expect(event_address(event)).to be(event.building.address_city)
    end

    it "returns the address, comma separated with line breaks between parts" do
      expect(event.building).not_to be_nil
      expect(event_address(event)).to eq("Line 1,\nLine 2,\nManchester,\nMA1 1AM")
    end

    it "returns the address, when all fields have values" do
      event.building = building_fully_populated
      expect(event_address(event)).to eq("Line 1,\nLine 2,\nLine 3,\nManchester,\nMA1 1AM")
    end
  end

  describe "#display_event_provider_info?" do
    it "returns false if get into teaching event" do
      event.type_id = Crm::EventType.get_into_teaching_event_id
      expect(display_event_provider_info?(event)).to be(false)
    end

    it "returns true if not get into teaching event" do
      event.type_id = Crm::EventType.online_event_id
      expect(display_event_provider_info?(event)).to be(true)
      event.type_id = Crm::EventType.school_or_university_event_id
      expect(display_event_provider_info?(event)).to be(true)
    end
  end

  describe "#event_has_provider_info?" do
    it "returns true if the event has provider information" do
      event = build(:event_api, :with_provider_info)
      expect(event_has_provider_info?(event)).to be_truthy
    end

    it "returns false if the event has no provider information" do
      event = build(:event_api)
      expect(event_has_provider_info?(event)).to be_falsy
    end
  end

  describe "#categorise_events" do
    let(:events) { build_list(:event_api, 2) }
    let(:params) { {} }

    subject(:categorised_events) { categorise_events(events, params) }

    it { expect(categorised_events.count).to eq(events.count) }
    it { is_expected.to all(have_attributes(title: be_a(String), description: be_a(String), path: be_a(String))) }

    context "when the event does not have a building" do
      let(:events) { build_list(:event_api, 2, :online) }

      it { is_expected.to all(have_attributes(title: be_a(String), description: be_a(String), path: be_a(String))) }
    end

    context "when the event has a channel" do
      let(:params) { { channel: "123" } }

      it "includes the channel in the path" do
        expect(categorised_events.first.path).to include("channel=123")
      end
    end

    context "when the event has a sub_channel" do
      let(:params) { { sub_channel: "ABC" } }

      it "includes the channel in the path" do
        expect(categorised_events.first.path).to include("sub_channel=ABC")
      end
    end
  end

  describe "#pluralised_category_name" do
    {
      222_750_012 => "Get Into Teaching events",
      222_750_008 => "Online Q&As",
      222_750_009 => "School and University events",
    }.each do |type_id, name|
      specify "#{type_id} => #{name}" do
        expect(pluralised_category_name(type_id)).to eql(name)
      end
    end
  end

  describe "#display_no_git_events_message?" do
    let(:performed_search) { true }
    let(:events) { [] }
    let(:event_search_type) { "222750012" }
    let(:dummy_events) { [[222_750_012, []]] }

    it "returns true when searching for GIT events and there are none" do
      expect(display_no_git_events_message?(performed_search, events, event_search_type)).to be true
    end

    it "returns false when search was not performed" do
      expect(display_no_git_events_message?(false, events, event_search_type)).to be false
    end

    it "returns false when there are GIT events" do
      expect(display_no_git_events_message?(true, dummy_events, event_search_type)).to be false
    end

    it "returns false when the search is not for GIT events" do
      expect(display_no_git_events_message?(true, dummy_events, "")).to be false
    end
  end

  describe "#show_see_all_events_button?" do
    let(:type_id) { Crm::EventType.get_into_teaching_event_id }

    context "when checking for GIT event type id" do
      it "returns false when events is empty" do
        events = []

        expect(show_see_all_events_button?(type_id, events)).to be false
      end

      it "returns true when events is not empty" do
        events = build_list(:event_api, 2, :get_into_teaching_event)

        expect(show_see_all_events_button?(type_id, events)).to be true
      end
    end

    context "when checking for any other event type ids" do
      let(:type_id) { Crm::EventType.online_event_id }

      it "returns true when events is empty" do
        events = build_list(:event_api, 2, :online_event)

        expect(show_see_all_events_button?(type_id, events)).to be true
      end

      it "returns true when events is not empty" do
        events = []

        expect(show_see_all_events_button?(type_id, events)).to be true
      end
    end
  end

  describe "#git_event_type_id?" do
    it "returns the GIT event id" do
      expect(git_event_type_id).to eq Crm::EventType.get_into_teaching_event_id
    end
  end
end
