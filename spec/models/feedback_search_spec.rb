require "rails_helper"

RSpec.describe FeedbackSearch do
  let(:instance) { described_class.new }

  describe "attributes" do
    it { is_expected.to respond_to :created_on_or_after }
    it { is_expected.to respond_to :created_on_or_before }
  end

  describe "validation" do
    it { is_expected.to validate_presence_of(:created_on_or_before) }
    it { is_expected.to validate_presence_of(:created_on_or_after) }
    it { is_expected.to allow_value(Time.zone.now.utc, 1.day.ago).for :created_on_or_before }
    it { is_expected.not_to allow_value(2.days.from_now).for :created_on_or_before }

    context "when created_on_or_before is 5/2/2020" do
      before { subject.created_on_or_before = Date.new(2020, 2, 5) }

      it { is_expected.to allow_value(subject.created_on_or_before).for :created_on_or_after }
      it { is_expected.not_to allow_value(Date.new(2020, 2, 6)).for :created_on_or_after }
    end
  end

  describe "#created_on_or_after" do
    subject { instance.created_on_or_after }

    it { is_expected.to eq(Time.zone.now.beginning_of_month.utc.to_date) }
  end

  describe "#created_on_or_before" do
    subject { instance.created_on_or_before }

    it { is_expected.to eq(Time.zone.now.end_of_day.utc.to_date) }
  end

  describe "#range" do
    subject { instance.range }

    let(:instance) do
      described_class.new(
        created_on_or_after: Time.zone.local(2021, 2, 22),
        created_on_or_before: Time.zone.local(2021, 3, 11),
      )
    end

    it do
      expect(subject).to eq([
        instance.created_on_or_after,
        instance.created_on_or_before,
      ])
    end
  end

  describe "#results" do
    subject { instance.results }

    let(:instance) do
      described_class.new(
        created_on_or_after: Time.zone.local(2020, 10, 1),
        created_on_or_before: Time.zone.local(2020, 10, 5),
      )
    end

    before do
      on_or_after = instance.created_on_or_after
      on_or_before = instance.created_on_or_before

      ((on_or_after - 2.days)..(on_or_before + 2.days)).each do |date|
        create(:user_feedback).tap do |feedback|
          feedback.update(created_at: date)
        end
      end
    end

    it "returns feedback in the date range and orders by latest first" do
      dates = subject.map(&:created_at)

      expect(subject.count).to eq(5)
      expect(dates).to eq(dates.sort.reverse)
    end

    context "when invalid" do
      before { allow(instance).to receive(:invalid?).and_return(true) }

      it { is_expected.to eq([]) }
    end
  end
end
