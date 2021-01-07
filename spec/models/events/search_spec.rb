require "rails_helper"

describe Events::Search do
  describe "attributes" do
    it { is_expected.to respond_to :type }
    it { is_expected.to respond_to :distance }
    it { is_expected.to respond_to :postcode }
    it { is_expected.to respond_to :month }
    it { is_expected.to respond_to :period }
  end

  describe "#period" do
    subject { described_class.new.period }
    it { is_expected.to eq(:future) }
  end

  describe ".available_distance_keys" do
    subject { described_class.new.available_distance_keys }
    it { is_expected.to eql [nil, 30, 50, 100] }
  end

  describe ".available_event_type_ids" do
    subject { described_class.new.available_event_type_ids }
    it { is_expected.to eql GetIntoTeachingApiClient::Constants::EVENT_TYPES.values }
  end

  describe "#future?" do
    it { expect(described_class.new(period: :future)).to be_future }
    it { expect(described_class.new(period: :past)).not_to be_future }
  end

  describe "#available_months" do
    before { travel_to(DateTime.new(2020, 11, 10)) }
    subject { described_class.new(period: period).available_months }

    context "when period is future" do
      let(:period) { :future }

      it {
        is_expected.to eq([
          ["November 2020", "2020-11"],
          ["December 2020", "2020-12"],
          ["January 2021", "2021-01"],
          ["February 2021", "2021-02"],
          ["March 2021", "2021-03"],
          ["April 2021", "2021-04"],
        ])
      }
    end

    context "when period is past" do
      let(:period) { :past }

      it {
        is_expected.to eq([
          ["November 2020", "2020-11"],
          ["October 2020", "2020-10"],
          ["September 2020", "2020-09"],
          ["August 2020", "2020-08"],
        ])
      }

      context "when today is first day of month" do
        before { travel_to(DateTime.new(2020, 11, 1)) }

        it {
          is_expected.to eq([
            ["October 2020", "2020-10"],
            ["September 2020", "2020-09"],
            ["August 2020", "2020-08"],
            ["July 2020", "2020-07"],
          ])
        }
      end
    end
  end

  describe "validations" do
    describe "event #type" do
      it { is_expected.to allow_value(GetIntoTeachingApiClient::Constants::EVENT_TYPES["Teain to Teach event"]).for :type }
      it { is_expected.to allow_value(GetIntoTeachingApiClient::Constants::EVENT_TYPES["Teain to Teach event"].to_s).for :type }
      it { is_expected.to allow_value(nil).for :type }
      it { is_expected.to allow_value("").for :type }
      it { is_expected.not_to allow_value("2").for :type }
    end

    describe "#period" do
      it { is_expected.to allow_values(:past, :future).for :period }
      it { is_expected.not_to allow_values(nil, "", :present).for :period }
    end

    describe "#distance" do
      described_class::DISTANCES.each do |distance|
        it { is_expected.to allow_value(distance.to_s).for :distance }
      end

      it { is_expected.to allow_value("").for :distance }
      it { is_expected.not_to allow_value("foo").for :distance }
      it { is_expected.not_to allow_value(1000).for :distance }
    end

    describe "#postcode" do
      context "with blank distance" do
        subject { described_class.new distance: nil }

        it { is_expected.to allow_value(nil).for :postcode }
        it { is_expected.to allow_value("").for :postcode }
        it { is_expected.to allow_value("random").for :postcode }
      end

      context "with assigned distance" do
        let(:msg) { "Enter valid full postcode or first part" }

        subject do
          described_class.new distance: described_class::DISTANCES.first
        end

        it { is_expected.not_to allow_value("").for :postcode }
        it { is_expected.not_to allow_value(nil).for :postcode }
        it { is_expected.not_to allow_value("random").for :postcode }
        it { is_expected.to allow_value("MA1 2WD").for :postcode }
        it { is_expected.not_to allow_value("TE57 ING").for(:postcode).with_message(msg) }
      end
    end

    describe "#month" do
      it { is_expected.to allow_value("2020-01").for(:month) }
      it { is_expected.to allow_value("2020-12").for(:month) }
      it { is_expected.to allow_value("").for(:month) }
      it { is_expected.to allow_value(nil).for(:month) }
      it { is_expected.not_to allow_value("2020-00").for(:month) }
      it { is_expected.not_to allow_value("2020-13").for(:month) }
      it { is_expected.not_to allow_value("1900-01").for(:month) }
      it { is_expected.not_to allow_value("foo").for(:month) }
    end
  end

  describe "#query_events" do
    let(:default_limit) { described_class::RESULTS_PER_TYPE }

    subject { build :events_search }
    before { allow(subject).to receive(:valid?).and_return is_valid }

    let(:expected_attributes) do
      {
        type_id: subject.type,
        radius: subject.distance,
        postcode: subject.postcode,
        start_after: DateTime.now.utc.beginning_of_day,
        start_before: DateTime.now.utc.end_of_month.end_of_month,
        quantity_per_type: default_limit,
      }
    end

    context "when valid" do
      let(:is_valid) { true }
      after { subject.send(:query_events) }

      it "calls the API" do
        expect_any_instance_of(GetIntoTeachingApiClient::TeachingEventsApi).to \
          receive(:search_teaching_events_indexed_by_type).with(**expected_attributes)
      end

      context "when there's whitespace around a provided postcode" do
        subject { build(:events_search, postcode: " te57 1ng  ").tap(&:validate) }

        it "the whitespace is stripped before querying the API" do
          expect_any_instance_of(GetIntoTeachingApiClient::TeachingEventsApi).to \
            receive(:search_teaching_events_indexed_by_type).with(**expected_attributes.merge(postcode: "TE57 1NG"))
        end
      end

      context "when searching a future period" do
        let(:travel_date) { DateTime.new(2020, 1, 10).utc }
        before { travel_to(travel_date) }

        context "when the month is nil" do
          subject { build(:events_search, month: nil).tap(&:validate) }

          it "searches from the beginning of today to the end of the next 5 months" do
            expect_any_instance_of(GetIntoTeachingApiClient::TeachingEventsApi).to \
              receive(:search_teaching_events_indexed_by_type)
                .with(**expected_attributes.merge(start_after: travel_date.beginning_of_day, start_before: DateTime.new(2020, 6, 30).end_of_day))
          end
        end

        context "when the month is the current month" do
          let(:date) { travel_date }
          subject { build(:events_search, month: date.to_formatted_s(:humanmonthyear)).tap(&:validate) }

          it "searches from the beginning of today to the end of the current month" do
            expect_any_instance_of(GetIntoTeachingApiClient::TeachingEventsApi).to \
              receive(:search_teaching_events_indexed_by_type)
                .with(**expected_attributes.merge(start_after: date.beginning_of_day, start_before: date.end_of_month))
          end
        end

        context "when the month is the next month" do
          let(:date) { travel_date.advance(months: 1) }
          subject { build(:events_search, month: date.to_formatted_s(:humanmonthyear)).tap(&:validate) }

          it "searches from the start of the next month to the end" do
            expect_any_instance_of(GetIntoTeachingApiClient::TeachingEventsApi).to \
              receive(:search_teaching_events_indexed_by_type)
                .with(**expected_attributes.merge(start_after: date.beginning_of_month, start_before: date.end_of_month))
          end
        end
      end

      context "when searching a past period" do
        let(:travel_date) { DateTime.new(2020, 1, 10).utc }
        let(:day_before_travel_date) { travel_date.advance(days: -1) }
        before { travel_to(travel_date) }

        context "when the month is nil" do
          subject { build(:events_search, month: nil, period: :past).tap(&:validate) }

          it "searches from the start of 4 months ago to the end of yesterday" do
            expect_any_instance_of(GetIntoTeachingApiClient::TeachingEventsApi).to \
              receive(:search_teaching_events_indexed_by_type)
                .with(**expected_attributes.merge(start_after: DateTime.new(2019, 10, 1).beginning_of_day, start_before: day_before_travel_date.end_of_day))
          end
        end

        context "when the month is the current month" do
          let(:date) { travel_date }
          subject { build(:events_search, month: date.to_formatted_s(:humanmonthyear), period: :past).tap(&:validate) }

          it "searches from the beginning of the month to the end of yesterday" do
            expect_any_instance_of(GetIntoTeachingApiClient::TeachingEventsApi).to \
              receive(:search_teaching_events_indexed_by_type)
                .with(**expected_attributes.merge(start_after: date.beginning_of_month, start_before: day_before_travel_date.end_of_day))
          end
        end

        context "when the month is the previous month" do
          let(:date) { travel_date.advance(months: -1) }
          subject { build(:events_search, month: date.to_formatted_s(:humanmonthyear), period: :past).tap(&:validate) }

          it "searches from the start of the previous month to the end" do
            expect_any_instance_of(GetIntoTeachingApiClient::TeachingEventsApi).to \
              receive(:search_teaching_events_indexed_by_type)
                .with(**expected_attributes.merge(start_after: date.beginning_of_month, start_before: date.end_of_month))
          end
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
end
