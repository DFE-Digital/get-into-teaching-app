require "rails_helper"

describe EventsHelper, type: "helper" do
  let(:startdate) { DateTime.new(2020, 6, 1, 10) }
  let(:enddate) { DateTime.new(2020, 6, 1, 12) }
  let(:event) { build(:event_api, start_at: startdate, end_at: enddate) }

  describe "#format_event_date" do
    let(:stacked) { true }
    subject { format_event_date event, stacked: stacked }

    context "for single day event" do
      it { is_expected.to eql "June 1st, 2020 <br /> 10:00 - 12:00" }
    end

    context "for multi day event" do
      let(:enddate) { DateTime.new(2020, 6, 4, 14) }
      it { is_expected.to eql "June 1st, 2020 10:00 to June 4th, 2020 14:00" }
    end

    context "when not stacked" do
      let(:stacked) { false }

      it { is_expected.to eql "June 1st, 2020 at 10:00 - 12:00" }
    end
  end

  describe "#name_of_event_type" do
    include_context "stub types api"

    it "returns the name of the given event type id" do
      type_id = GetIntoTeachingApiClient::Constants::EVENT_TYPES["Train to Teach Event"]
      expect(name_of_event_type(type_id)).to eq("Train to Teach Event")
    end

    it "returns an empty string if the event type cannot be found" do
      expect(name_of_event_type(-1)).to be_empty
    end
  end

  describe "#event_type_color" do
    it "returns green for train to teach events" do
      type_id = GetIntoTeachingApiClient::Constants::EVENT_TYPES["Train to Teach Event"]
      expect(event_type_color(type_id)).to eq("green")
    end

    it "returns purple for online events" do
      type_id = GetIntoTeachingApiClient::Constants::EVENT_TYPES["Online Event"]
      expect(event_type_color(type_id)).to eq("purple")
    end

    it "returns yellow for application workshop" do
      type_id = GetIntoTeachingApiClient::Constants::EVENT_TYPES["Application Workshop"]
      expect(event_type_color(type_id)).to eq("yellow")
    end

    it "returns blue for schools or university events" do
      type_id = GetIntoTeachingApiClient::Constants::EVENT_TYPES["Schools or University Events"]
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
      expect(event.building).to_not be_nil
      expect(event_address(event)).to eq("Line 1,\nLine 2,\nManchester,\nMA1 1AM")
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
end
