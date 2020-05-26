require "rails_helper"

describe Events::Search do
  let(:event_types) do
    {
      0 => "first",
      1 => "second",
    }
  end

  before do
   # allow(GetIntoTeachingApi::Client).to receive(:event_types) { event_types }
  end

  context "attributes" do
    it { is_expected.to respond_to :event_type }
    it { is_expected.to respond_to :distance }
    it { is_expected.to respond_to :location }
    it { is_expected.to respond_to :month }
  end

  context "validation" do
    context "for event type" do
      it { is_expected.to allow_value(0).for :event_type }
      it { is_expected.to allow_value("1").for :event_type }
      it { is_expected.not_to allow_value("2").for :event_type }
      it { is_expected.not_to allow_value("").for :event_type }
    end

    context "for distance" do
      described_class::DISTANCES.each do |distance|
        it { is_expected.to allow_value(distance.to_s).for :distance }
      end

      it { is_expected.to allow_value("").for :distance }
      it { is_expected.not_to allow_value("foo").for :distance }
      it { is_expected.not_to allow_value(1000).for :distance }
    end

    context "for location" do
      context "with blank distance" do
        subject { described_class.new distance: nil }

        it { is_expected.to allow_value(nil).for :location }
        it { is_expected.to allow_value("").for :location }
        it { is_expected.to allow_value("random").for :location }
      end

      context "with assigned distance" do
        subject do
          described_class.new distance: described_class::DISTANCES.first
        end

        it { is_expected.not_to allow_value("").for :location }
        it { is_expected.not_to allow_value(nil).for :location }
        it { is_expected.not_to allow_value("random").for :location }
        it { is_expected.to allow_value("MA1 2WD").for :location }
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
    before { allow(subject).to receive(:query_events_api).and_return [] }
    before { allow(subject).to receive(:valid?).and_return is_valid }
    before { subject.query_events }

    context "when valid" do
      let(:is_valid) { true }
      it { is_expected.to have_received(:query_events_api) }
    end

    context "when invalid" do
      let(:is_valid) { false }
      it { is_expected.not_to have_received(:query_events_api) }
    end
  end
end
