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
      OpenStruct.new(type_id: EventType.lookup_by_name(ttt))
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
      expect(event_type_name(222_750_007)).to eql("Question Time")
    end

    specify "returns nil when given an invalid id" do
      expect(event_type_name(987_654_321)).to be nil
    end

    context "when overriding values" do
      let(:custom_event) { "Bingo night" }

      specify "returns online forum instead of online event by default" do
        expect(EventType.lookup_by_id(222_750_008)).to eql("Online event")
        expect(event_type_name(222_750_008)).to eql("DfE Online Q&A")
      end

      specify "returns training provider instead of school or uni event by default" do
        expect(EventType.lookup_by_id(222_750_009)).to eql("School or University event")
        expect(event_type_name(222_750_009)).to eql("Training provider")
      end

      specify "allows the arbitrary overriding of event types" do
        expect(event_type_name(123, overrides: { custom_event => 123 })).to eql(custom_event)
      end
    end
  end

  describe "#is_a_train_to_teach_event?" do
    let(:ttt_event) { OpenStruct.new(type_id: EventType.train_to_teach_event_id) }
    let(:qt_event) { OpenStruct.new(type_id: EventType.question_time_event_id) }
    let(:online_event) { OpenStruct.new(type_id: EventType.online_event_id) }
    let(:school_or_university_event) { OpenStruct.new(type_id: EventType.school_or_university_event_id) }

    specify "returns true when the event is either Train to Teach or Question Time" do
      expect(is_a_train_to_teach_event?(ttt_event)).to be true
      expect(is_a_train_to_teach_event?(qt_event)).to be true
    end

    specify "returns false when the event is online or school and university" do
      expect(is_a_train_to_teach_event?(online_event)).to be false
      expect(is_a_train_to_teach_event?(school_or_university_event)).to be false
    end
  end
end
