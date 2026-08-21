require "rails_helper"

RSpec.describe ProviderEvents::Steps::EventTimes do
  include_context "with wizard step"

  around do |example|
    freeze_time(&example)
  end

  before do
    allow(instance).to receive(:other_step).with(:event_date) { instance_double(ProviderEvents::Steps::EventDate, event_date: event_date) }

    allow(instance).to receive(:"start_time(4i)") { start_time_hour }
    allow(instance).to receive(:"start_time(5i)") { start_time_min }
    allow(instance).to receive(:"end_time(4i)") { end_time_hour }
    allow(instance).to receive(:"end_time(5i)") { end_time_min }
  end

  let(:timezone) { ActiveSupport::TimeZone["Europe/London"] }
  let(:event_date) { nil }
  let(:start_time_hour) { instance.start_time&.hour }
  let(:start_time_min) { instance.start_time&.min }
  let(:end_time_hour) { instance.end_time&.hour }
  let(:end_time_min) { instance.end_time&.min }

  it_behaves_like "a with wizard step"

  it { is_expected.not_to be_skipped }

  describe "start_time" do
    let(:past_time) { timezone.now - 3.minutes }
    let(:future_time) { timezone.now + 3.minutes }

    it { is_expected.to respond_to :start_time }
    it { is_expected.to validate_presence_of :start_time }

    context "with event_date" do
      context "when not set" do
        it { is_expected.to allow_value(past_time).for(:start_time) }
        it { is_expected.to allow_value(future_time).for(:start_time) }
      end

      context "when set to today" do
        let(:event_date) { timezone.today }

        it { is_expected.not_to allow_value(past_time).for(:start_time).with_message("Can't be in the past") }
        it { is_expected.to allow_value(future_time).for(:start_time) }
      end

      context "when set to the future" do
        let(:event_date) { timezone.tomorrow }

        it { is_expected.to allow_value(past_time).for(:start_time) }
        it { is_expected.to allow_value(future_time).for(:start_time) }
      end
    end
  end

  describe "end_time" do
    before do
      allow(instance).to receive(:"start_time(4i)") { start_time&.hour }
      allow(instance).to receive(:"start_time(5i)") { start_time&.min }
    end

    let(:start_time) { nil }
    let(:before_time) { timezone.parse("13:45") }
    let(:after_time) { timezone.parse("14:00") }

    it { is_expected.to respond_to :end_time }
    it { is_expected.to validate_presence_of :end_time }

    context "when start_time is not set" do
      it { is_expected.to allow_value(before_time).for(:end_time) }
      it { is_expected.to allow_value(after_time).for(:end_time) }
      it { is_expected.not_to validate_comparison_of(:end_time) }
    end

    context "when start_time is set" do
      let(:start_time) { before_time }

      it { is_expected.not_to allow_value(before_time).for(:end_time) }
      it { is_expected.to allow_value(after_time).for(:end_time) }
    end
  end

  describe "start_at and end_at" do
    let(:start_time_hour) { 9 }
    let(:start_time_min) { 18 }
    let(:end_time_hour) { 16 }
    let(:end_time_min) { 32 }

    context "when BST (summer time)" do
      let(:event_date) { Date.parse("2026-07-08") }

      it "casts the start time from BST to UTC" do
        expect(instance.start_at).to eql(Time.utc(2026, 0o7, 8, 8, 18))
      end

      it "casts the end time from BST to UTC" do
        expect(instance.end_at).to eql(Time.utc(2026, 0o7, 8, 15, 32))
      end
    end

    context "when GMT" do
      let(:event_date) { Date.parse("2026-02-03") }

      it "casts the start time from BST to UTC" do
        expect(instance.start_at).to eql(Time.utc(2026, 2, 3, 9, 18))
      end

      it "casts the end time from BST to UTC" do
        expect(instance.end_at).to eql(Time.utc(2026, 2, 3, 16, 32))
      end
    end
  end
end
