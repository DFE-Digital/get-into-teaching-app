require "rails_helper"

describe EventsHelper, type: "helper" do
  include MapsHelper

  let(:startdate) { DateTime.new(2020, 6, 1, 10) }
  let(:enddate) { DateTime.new(2020, 6, 1, 12) }
  let(:event) { build(:event_api, start_at: startdate, end_at: enddate) }
  let(:building_fully_populated) { build(:event_building_api, address_line3: "Line 3") }

  describe "#format_event_date" do
    let(:stacked) { true }
    subject { format_event_date event, stacked: stacked }

    context "with a single day event" do
      it { is_expected.to eql "1 June 2020 <br> 10:00 - 12:00" }
    end

    context "with a multi day event" do
      let(:enddate) { DateTime.new(2020, 6, 4, 14) }
      it { is_expected.to eql "1 June 2020 10:00 to 4 June 2020 14:00" }
    end

    context "when not stacked" do
      let(:stacked) { false }

      it { is_expected.to eql "1 June 2020 at 10:00 - 12:00" }
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
      allow(Rails.application.config.x).to receive(:google_maps_key) { "12345" }
    end

    it { is_expected.to match(/data-map-description=\"Line 1,\nLine 2,\nManchester,\nMA1 1AM\" /) }
    it { is_expected.to match(/zoom=10/) }
    it { is_expected.to match(/alt=\"Map showing #{event.name}\"/) }
  end

  describe "#event_status_open?" do
    it "returns true for events that have a status of open" do
      event = GetIntoTeachingApiClient::TeachingEvent.new(
        statusId: GetIntoTeachingApiClient::Constants::EVENT_STATUS["Open"],
      )
      expect(event_status_open?(event)).to be_truthy
    end

    it "returns false for closed events" do
      event = GetIntoTeachingApiClient::TeachingEvent.new(
        statusId: GetIntoTeachingApiClient::Constants::EVENT_STATUS["Closed"],
      )
      expect(event_status_open?(event)).to be_falsy
    end
  end

  describe "#can_sign_up_online?" do
    it "returns true for events with a web_feed_id that are not closed" do
      event = GetIntoTeachingApiClient::TeachingEvent.new(
        webFeedId: "abc-123",
        statusId: GetIntoTeachingApiClient::Constants::EVENT_STATUS["Open"],
      )
      expect(can_sign_up_online?(event)).to be_truthy
    end

    it "returns false for events without a web_feed_id" do
      event = GetIntoTeachingApiClient::TeachingEvent.new(
        webFeedId: nil,
        statusId: GetIntoTeachingApiClient::Constants::EVENT_STATUS["Open"],
      )
      expect(can_sign_up_online?(event)).to be_falsy
    end

    it "returns false for closed events" do
      event = GetIntoTeachingApiClient::TeachingEvent.new(
        webFeedId: "abc-123",
        statusId: GetIntoTeachingApiClient::Constants::EVENT_STATUS["Closed"],
      )
      expect(can_sign_up_online?(event)).to be_falsy
    end
  end

  describe "#is_event_type?" do
    let(:matching_type) { "School or University event" }
    let(:non_matching_type) { "Online event" }
    let(:event) { build(:event_api, type_id: GetIntoTeachingApiClient::Constants::EVENT_TYPES[matching_type]) }

    it "should be truthy when the type matches" do
      expect(is_event_type?(event, matching_type)).to be_truthy
    end

    it "should be falsy when the type matches" do
      expect(is_event_type?(event, non_matching_type)).to be_falsy
    end
  end

  describe "#event_type_color" do
    it "returns purple for train to teach events" do
      type_id = GetIntoTeachingApiClient::Constants::EVENT_TYPES["Train to Teach event"]
      expect(event_type_color(type_id)).to eq("purple")
    end

    it "returns blue for non-train to teach events" do
      type_id = GetIntoTeachingApiClient::Constants::EVENT_TYPES["Online event"]
      expect(event_type_color(type_id)).to eq("blue")
      type_id = GetIntoTeachingApiClient::Constants::EVENT_TYPES["Schools or University event"]
      expect(event_type_color(type_id)).to eq("blue")
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

  describe "#embed_event_video_url" do
    it "returns nil if the event video is nil" do
      expect(embed_event_video_url(nil)).to be_nil
    end

    it "returns an embedded url when given an embedded url" do
      standard_url = "https://www.youtube.com/watch?v=BelJ2AjtHoQ"
      embed_url = "https://www.youtube.com/embed/BelJ2AjtHoQ"
      expect(embed_event_video_url(standard_url)).to eq(embed_url)
    end

    it "returns an embedded url when given a standard url" do
      embed_url = "https://www.youtube.com/embed/BelJ2AjtHoQ"
      expect(embed_event_video_url(embed_url)).to eq(embed_url)
    end
  end

  describe "#pluralised_category_name" do
    {
      222_750_001 => "Train to Teach events",
      222_750_008 => "Online Q&As",
      222_750_009 => "School and University events",
    }.each do |type_id, name|
      specify "#{type_id} => #{name}" do
        expect(pluralised_category_name(type_id)).to eql(name)
      end
    end
  end

  describe "#past_category_name" do
    it "returns 'Past online Q&As' if the category name contains 'online'" do
      expect(past_category_name(222_750_008)).to eql("Past online Q&As")
    end

    it "returns the category name with 'Past' prepended if the category name does not contain 'online'" do
      expect(past_category_name(222_750_001)).to eql("Past Train to Teach events")
    end
  end
end
