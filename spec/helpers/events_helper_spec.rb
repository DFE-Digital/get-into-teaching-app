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

  describe "#train_to_teach_event_type?" do
    include_context "stub types api"

    it "returns true for train to teach events" do
      type_id = GetIntoTeachingApiClient::Constants::EVENT_TYPES["Train to Teach Event"]
      expect(train_to_teach_event_type?(type_id)).to be_truthy
    end

    it "returns false for other event types" do
      expect(train_to_teach_event_type?(-1)).to be_falsy
    end
  end

  describe "#event_address" do
    it "returns nil if the event has no building" do
      event.building = nil
      expect(event_address(event)).to be_nil
    end

    it "returns the address, comma separated with line breaks between parts" do
      expect(event.building).to_not be_nil
      expect(event_address(event)).to eq("Line 1,\nLine 2,\nManchester,\nMA1 1AM")
    end
  end
end
