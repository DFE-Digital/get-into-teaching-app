require "validate_url/rspec_matcher"
require "rails_helper"

RSpec.describe ProviderEvents::Steps::EventDateTimes do
  include_context "with wizard step"

  around do |example|
    freeze_time(&example)
  end

  it_behaves_like "a with wizard step"

  it { is_expected.not_to be_skipped }

  describe "start_date_time" do
    it { is_expected.to respond_to :start_date_time }
    it { is_expected.to validate_presence_of :start_date_time }
    it { is_expected.to validate_comparison_of(:start_date_time).is_greater_than(Time.zone.now) }
  end

  describe "end_date_time" do
    it { is_expected.to respond_to :end_date_time }
    it { is_expected.to validate_presence_of :end_date_time }

    context "when start_date_time is set" do
      before { subject.start_date_time = Time.zone.now + 30.minutes }

      it { is_expected.to validate_comparison_of(:end_date_time).is_greater_than(:start_date_time) }
      it { is_expected.to validate_comparison_of(:end_date_time).is_less_than(Time.zone.now.midnight + 1.day) }
    end
  end
end
