require "rails_helper"

describe TeachingEvents::Search do
  describe "attributes" do
    subject { described_class.new }

    it { is_expected.to respond_to(:postcode) }
    it { is_expected.to respond_to(:online) }
    it { is_expected.to respond_to(:type) }
    it { is_expected.to respond_to(:distance) }
  end

  describe "validation" do
    describe "postcode" do
      describe "before_validation" do
        subject { described_class.new(postcode: "m1 2wd ") }

        before { subject.valid? }

        specify "postcode is uppercased and has whitespace stripped" do
          expect(subject.postcode).to eql("M1 2WD")
        end
      end

      context "when distance is set" do
        subject { described_class.new(distance: 30) }

        ["M1 2WD", "M1"].each do |val|
          it { is_expected.to allow_value(val).for(:postcode) }
        end

        [nil, "", "M", "Manchester", "M1-2WD"].each do |val|
          it { is_expected.not_to allow_value(val).for(:postcode) }
        end
      end

      context "when distance isn't set" do
        it { is_expected.to allow_value(nil).for(:postcode) }
      end
    end

    describe "distance" do
      subject { described_class.new(postcode: "M1 2WD") }

      let(:allowed_distances) { described_class::DISTANCES.values }

      it { is_expected.to allow_values(allowed_distances).for(:distance) }
    end
  end

  describe "#results" do
    event_types   = GetIntoTeachingApiClient::Constants::EVENT_TYPES
    ttt           = event_types["Train to Teach event"]
    qt            = event_types["Question Time"]
    online        = event_types["Online event"]
    school_or_uni = event_types["School or University event"]

    let(:fake_api) do
      instance_double(
        GetIntoTeachingApiClient::TeachingEventsApi,
        search_teaching_events_grouped_by_type: [],
      )
    end

    before { allow(GetIntoTeachingApiClient::TeachingEventsApi).to receive(:new).and_return(fake_api) }

    [
      # online / offline

      OpenStruct.new(
        description: "when both online and in person are checked",
        input: { online: %w[true false] },
        expected_conditions: { online: nil },
      ),
      OpenStruct.new(
        description: "neither online and in person are checked",
        input: { online: %w[] },
        expected_conditions: { online: nil },
      ),
      OpenStruct.new(
        description: "just online is checked",
        input: { online: %w[true] },
        expected_conditions: { online: true },
      ),
      OpenStruct.new(
        description: "just in person is checked",
        input: { online: %w[false] },
        expected_conditions: { online: false },
      ),

      # distance

      OpenStruct.new(
        description: "blank distance",
        input: { distance: "" },
        expected_conditions: { radius: nil },
      ),

      OpenStruct.new(
        description: "distance of 22 miles",
        input: { distance: "22" },
        expected_conditions: { radius: 22 },
      ),

      # postcode

      OpenStruct.new(
        description: "blank postcode",
        input: { postcode: "" },
        expected_conditions: { postcode: nil },
      ),

      OpenStruct.new(
        description: "postcode of 'M1 2WD'",
        input: { postcode: "M1 2WD" },
        expected_conditions: { postcode: "M1 2WD" },
      ),

      # types

      OpenStruct.new(
        description: "No types",
        input: { type: [] },
        expected_conditions: { type_ids: nil },
      ),

      OpenStruct.new(
        description: "Train to Teach and Online",
        input: { type: [ttt, online].map(&:to_s) },
        expected_conditions: { type_ids: [ttt, online] },
      ),

      OpenStruct.new(
        description: "School or University or Question Time",
        input: { type: [qt, school_or_uni].map(&:to_s) },
        expected_conditions: { type_ids: [qt, school_or_uni] },
      ),

      OpenStruct.new(
        description: "All types",
        input: { type: [qt, school_or_uni, ttt, online].map(&:to_s) },
        expected_conditions: { type_ids: [qt, school_or_uni, ttt, online] },
      ),
    ].each do |query|
      context "#{query.description} (#{query.input})" do
        before { freeze_time }

        subject! { described_class.new(**query.input).results }

        specify "passes the expected values to the search API (#{query.expected_conditions})" do
          expect(fake_api).to have_received(:search_teaching_events_grouped_by_type).with(hash_including(query.expected_conditions))
        end
      end
    end
  end

  describe "#start_after" do
    specify "is now" do
      expect(described_class.new.send(:start_after)).to be_within(1.second).of(Time.zone.now)
    end
  end

  describe "#start_before" do
    specify "is 6 months in the future" do
      expect(described_class.new.send(:start_before)).to be_within(1.second).of(6.months.from_now)
    end
  end
end
