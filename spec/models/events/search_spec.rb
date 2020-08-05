require "rails_helper"

describe Events::Search do
  include_context "stub types api"

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

  context "validation" do
    context "for event type" do
      it { is_expected.to allow_value(1).for :type }
      it { is_expected.to allow_value("1").for :type }
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
      it { is_expected.to allow_value("2020-01").for :month }
      it { is_expected.to allow_value("2020-12").for :month }
      it { is_expected.not_to allow_value("2020-00").for :month }
      it { is_expected.not_to allow_value("2020-13").for :month }
      it { is_expected.not_to allow_value("1900-01").for :month }
      it { is_expected.not_to allow_value("foo").for :month }
      it { is_expected.not_to allow_value("").for :month }
      it { is_expected.not_to allow_value(nil).for :month }
    end
  end

  describe "#query_events" do
    subject { build :events_search }
    before { allow(subject).to receive(:valid?).and_return is_valid }

    context "when valid" do
      let(:is_valid) { true }

      it "calls the API" do
        expect_any_instance_of(GetIntoTeachingApiClient::TeachingEventsApi).to \
          receive(:search_teaching_events).with(
            type_id: subject.type,
            radius: subject.distance,
            postcode: subject.postcode,
            start_after: Date.new(2020, 7, 1),
            start_before: Date.new(2020, 7, 31),
          )
        subject.query_events
      end
    end

    context "when invalid" do
      let(:is_valid) { false }

      it "does not call the API" do
        expect_any_instance_of(GetIntoTeachingApiClient::TeachingEventsApi).not_to \
          receive(:search_teaching_events)
        subject.query_events
      end
    end
  end
end
