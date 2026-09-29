require "rails_helper"

describe CoerceToLondonTime do
  let(:testing_class) do
    Class.new do
      include CoerceToLondonTime
    end
  end

  let(:instance) { testing_class.new }

  let(:winter_time) { Time.utc(2026, 1, 6, 10, 30) }
  let(:summer_time) { Time.utc(2026, 7, 6, 10, 30) }

  describe "#coerce_to_london_time" do
    subject { instance.coerce_to_london_time(time) }

    context "when winter time" do
      let(:time) { winter_time }

      it { is_expected.to eql(Time.new(2026, 1, 6, 10, 30, 0, "Z")) }
    end

    context "when summer time" do
      let(:time) { summer_time }

      it { is_expected.to eql(Time.new(2026, 7, 6, 10, 30, 0, "+01:00")) }
    end
  end

  describe "#london_time_zone" do
    subject { instance.london_time_zone }

    it { is_expected.to eql(ActiveSupport::TimeZone["Europe/London"]) }
  end
end
