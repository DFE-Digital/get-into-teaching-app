require "rails_helper"

RSpec.describe ProviderEvents::Steps::EventTimes do
  include_context "with wizard step"

  around do |example|
    freeze_time(&example)
  end

  before do
    allow(instance).to receive(:other_step).with(:event_date) { instance_double(ProviderEvents::Steps::EventDate, event_date: event_date) }
  end

  let(:event_date) { nil }
  let(:millennium) { Time.zone.parse("2000-01-01") } # Time components do not have a date and are based on 01/01/2000
  let(:past_time) { millennium + (Time.zone.now-2.minutes).seconds_since_midnight }
  let(:future_time) { millennium + (Time.zone.now+2.minutes).seconds_since_midnight}

  it_behaves_like "a with wizard step"

  it { is_expected.not_to be_skipped }

  describe "start_time" do
    it { is_expected.to respond_to :start_time }
    it { is_expected.to validate_presence_of :start_time }

    context "with event_date" do
      context "when not set" do
        it { is_expected.to allow_value(past_time).for(:start_time) }
      end

      context "when set to today" do
        let(:event_date) { Time.zone.today }

        it { is_expected.not_to allow_value(past_time).for(:start_time).with_message("Can't be in the past") }
        it { is_expected.to allow_value(future_time).for(:start_time) }
      end

      context "when set to the future" do
        let(:event_date) { Time.zone.tomorrow }

        it { is_expected.to allow_value(past_time).for(:start_time) }
        it { is_expected.to allow_value(future_time).for(:start_time) }
      end
    end
  end

  describe "end_time" do
    it { is_expected.to respond_to :end_time }
    it { is_expected.to validate_presence_of :end_time }

    context "with start_time" do
      before { allow(instance).to receive(:start_time) { start_time } }

      context "when not set" do
        let(:start_time) { nil }
        it { is_expected.to allow_value(past_time).for(:end_time) }
        it { is_expected.not_to validate_comparison_of(:end_time) }
      end

      context "when set" do
        let(:start_time) { past_time }

        it { is_expected.to validate_comparison_of(:end_time).is_greater_than(:start_time) }
      end
    end
  end
end
