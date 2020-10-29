require "rails_helper"

describe Events::Search do
  context "attributes" do
    it { is_expected.to respond_to :type }
    it { is_expected.to respond_to :distance }
    it { is_expected.to respond_to :postcode }
    it { is_expected.to respond_to :month }
  end

  context "available_distance_keys" do
    subject { described_class.new.available_distance_keys }
    it { is_expected.to eql [nil, 30, 50, 100] }
  end

  context "available_event_type_ids" do
    subject { described_class.new.available_event_type_ids }
    it { is_expected.to eql GetIntoTeachingApiClient::Constants::EVENT_TYPES.values }
  end

  context "validation" do
    context "for event type" do
      it { is_expected.to allow_value(GetIntoTeachingApiClient::Constants::EVENT_TYPES["Teain to Teach event"]).for :type }
      it { is_expected.to allow_value(GetIntoTeachingApiClient::Constants::EVENT_TYPES["Teain to Teach event"].to_s).for :type }
      it { is_expected.to allow_value(nil).for :type }
      it { is_expected.to allow_value("").for :type }
      it { is_expected.not_to allow_value("2").for :type }
    end

    context "for distance" do
      described_class::DISTANCES.each do |distance|
        it { is_expected.to allow_value(distance.to_s).for :distance }
      end

      it { is_expected.to allow_value("").for :distance }
      it { is_expected.not_to allow_value("foo").for :distance }
      it { is_expected.not_to allow_value(1000).for :distance }
    end

    context "for postcode" do
      context "with blank distance" do
        subject { described_class.new distance: nil }

        it { is_expected.to allow_value(nil).for :postcode }
        it { is_expected.to allow_value("").for :postcode }
        it { is_expected.to allow_value("random").for :postcode }
      end

      context "with assigned distance" do
        subject do
          described_class.new distance: described_class::DISTANCES.first
        end

        it { is_expected.not_to allow_value("").for :postcode }
        it { is_expected.not_to allow_value(nil).for :postcode }
        it { is_expected.not_to allow_value("random").for :postcode }
        it { is_expected.to allow_value("MA1 2WD").for :postcode }
      end
    end

    context "for month" do
      it { is_expected.to allow_value("2020-01").for(:month).on(:search) }
      it { is_expected.to allow_value("2020-12").for(:month).on(:search) }
      it { is_expected.not_to allow_value("2020-00").for(:month).on(:search) }
      it { is_expected.not_to allow_value("2020-13").for(:month).on(:search) }
      it { is_expected.not_to allow_value("1900-01").for(:month).on(:search) }
      it { is_expected.not_to allow_value("foo").for(:month).on(:search) }
      it { is_expected.not_to allow_value("").for(:month).on(:search) }
      it { is_expected.not_to allow_value(nil).for(:month).on(:search) }
    end
  end

  shared_examples "interrogation" do
    subject { build :events_search }
    before { allow(subject).to receive(:valid?).and_return is_valid }

    let(:expected_attributes) do
      {
        type_id: subject.type,
        radius: subject.distance,
        postcode: subject.postcode,
        start_after: Date.new(2020, 7, 1),
        start_before: Date.new(2020, 7, 31),
        quantity_per_type: expected_limit,
      }
    end

    context "contextual validation" do
      let(:is_valid) { true }
      after { subject.send(*args) }

      before do
        allow_any_instance_of(GetIntoTeachingApiClient::TeachingEventsApi).to \
          receive(:search_teaching_events_indexed_by_type).and_return([])
      end

      specify "is validated in the correct context" do
        if validation_context
          expect(subject).to receive(:valid?).with(validation_context)
        else
          expect(subject).to receive(:valid?).with(no_args)
        end
      end
    end

    context "when valid" do
      let(:is_valid) { true }
      after { subject.send(*args) }

      it "calls the API" do
        expect_any_instance_of(GetIntoTeachingApiClient::TeachingEventsApi).to \
          receive(:search_teaching_events_indexed_by_type).with(**expected_attributes)
      end

      context "when there's whitespace around a provided postcode" do
        subject { build(:events_search, postcode: " TE57 1NG  ") }

        it "the whitespace is stripped before querying the API" do
          expect_any_instance_of(GetIntoTeachingApiClient::TeachingEventsApi).to \
            receive(:search_teaching_events_indexed_by_type).with(**expected_attributes.merge(postcode: subject.postcode.strip))
        end
      end
    end

    context "when invalid" do
      let(:is_valid) { false }

      it "does not call the API" do
        expect_any_instance_of(GetIntoTeachingApiClient::TeachingEventsApi).not_to \
          receive(:search_teaching_events_indexed_by_type)
        subject.query_events
      end
    end
  end

  describe "#query_events" do
    let(:expected_limit) { described_class::RESULTS_PER_TYPE }
    let(:args) { [:query_events] }
    let(:validation_context) { :search }
    include_examples "interrogation"
  end

  describe "#filter_events" do
    let(:provided_limit) { 50 }
    let(:expected_limit) { provided_limit }
    let(:validation_context) { nil }
    let(:args) { [:filter_events, provided_limit] }
    include_examples "interrogation"
  end
end
