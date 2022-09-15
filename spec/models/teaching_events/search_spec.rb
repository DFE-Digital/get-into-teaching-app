require "rails_helper"

describe TeachingEvents::Search do
  describe "attributes" do
    subject { described_class.new }

    it { is_expected.to respond_to(:postcode) }
    it { is_expected.to respond_to(:online) }
    it { is_expected.to respond_to(:type) }
    it { is_expected.to respond_to(:distance) }
  end

  describe ".encrypted_attributes" do
    subject { described_class.encrypted_attributes }

    it { is_expected.to eq(%w[postcode]) }
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

      context "when distance isn't set but postcode is" do
        subject { described_class.new(distance: nil) }

        it { is_expected.not_to allow_values("M", "Manchester", "M1-2WD").for(:postcode) }
        it { is_expected.to allow_value(nil, "").for(:postcode) }
      end
    end

    describe "distance" do
      subject { described_class.new(postcode: "M1 2WD") }

      let(:allowed_distances) { described_class::DISTANCES.values }

      it { is_expected.to allow_values(allowed_distances).for(:distance) }
    end
  end

  describe "#train_to_teach?" do
    let(:type) { %w[onlineqa ttt] }

    subject { described_class.new(type: type) }

    it { is_expected.to be_train_to_teach }

    context "when type does not contain train to teach" do
      let(:type) { %w[onlineqa] }

      it { is_expected.not_to be_train_to_teach }
    end

    context "when the type has not been set" do
      let(:type) { nil }

      it { is_expected.not_to be_train_to_teach }
    end
  end

  describe "online/in-person toggling" do
    let(:online) { nil }

    subject { described_class.new(online: online) }

    it { is_expected.not_to be_online_only }
    it { is_expected.not_to be_in_person_only }

    context "when online only" do
      let(:online) { ["true", ""] }

      it { is_expected.to be_online_only }
      it { is_expected.not_to be_in_person_only }
    end

    context "when in-person only" do
      let(:online) { ["false", ""] }

      it { is_expected.not_to be_online_only }
      it { is_expected.to be_in_person_only }
    end

    context "when online and in-person" do
      let(:online) { ["true", "false", ""] }

      it { is_expected.not_to be_online_only }
      it { is_expected.not_to be_in_person_only }
    end
  end

  describe "#results" do
    ttt           = "ttt"
    online        = "onlineqa"
    school_or_uni = "provider"

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
        expected_conditions: { type_ids: EventType.lookup_by_query_params(ttt, online) },
      ),

      OpenStruct.new(
        description: "School or University or Train to Teach",
        input: { type: [ttt, school_or_uni].map(&:to_s) },
        expected_conditions: { type_ids: EventType.lookup_by_query_params(ttt, school_or_uni) },
      ),

      OpenStruct.new(
        description: "All types",
        input: { type: [school_or_uni, ttt, online].map(&:to_s) },
        expected_conditions: { type_ids: EventType.lookup_by_query_params(school_or_uni, ttt, online) },
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
