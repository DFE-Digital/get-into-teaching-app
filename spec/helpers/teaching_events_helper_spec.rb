require "rails_helper"

describe TeachingEventsHelper, type: "helper" do
  describe "#event_list_id" do
    specify "returns the paramaterised name with a list suffix" do
      expect(event_list_id("Some name")).to eql("some-name-list")
    end
  end

  describe "#event_format" do
    [
      {
        description: "in person",
        expected_format: "In-person",
        event: OpenStruct.new(is_in_person: true, is_online: false, is_virtual: false),
      },
      {
        description: "online",
        expected_format: "Online",
        event: OpenStruct.new(is_in_person: false, is_online: true, is_virtual: false),
      },
      {
        description: "virtual",
        expected_format: "Online",
        event: OpenStruct.new(is_in_person: false, is_online: false, is_virtual: true),
      },
      {
        description: "online and in-person",
        expected_format: "In-person and online",
        event: OpenStruct.new(is_in_person: true, is_online: true, is_virtual: false),
      },
      {
        description: "online and virtual",
        expected_format: "Online",
        event: OpenStruct.new(is_in_person: false, is_online: true, is_virtual: true),
      },
      {
        description: "online, virtual and in person",
        expected_format: "In-person and online",
        event: OpenStruct.new(is_in_person: true, is_online: true, is_virtual: true),
      },

      # shouldn't get this, but if we do just return nil
      {
        description: "not online, virtual or in person",
        expected_format: nil,
        event: OpenStruct.new(is_in_person: false, is_online: false, is_virtual: false),
      },
    ].each do |params|
      describe "when the event is #{params[:description]}" do
        specify "the format should be '#{params[:expected_format]}'" do
          expect(event_format(params[:event])).to eql(params[:expected_format])
        end
      end
    end
  end

  describe "#is_event_type?" do
    let(:ttt) { "Train to Teach event" }
    let(:qt) { "Question Time" }

    let(:ttt_event) do
      OpenStruct.new(type_id: GetIntoTeachingApiClient::Constants::EVENT_TYPES[ttt])
    end

    specify "returns true when there's a match" do
      expect(is_event_type?(ttt_event, ttt)).to be true
    end

    specify "returns false when there's no match" do
      expect(is_event_type?(ttt_event, qt)).to be false
    end
  end

  describe "#event_type_name" do
    specify "returns the event name given a valid id" do
      expect(event_type_name(222_750_008)).to eql("Online event")
    end

    specify "returns nil when given an invalid id" do
      expect(event_type_name(987_654_321)).to be nil
    end
  end
end
