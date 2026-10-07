require "rails_helper"

RSpec.describe CoerceToLondonTime do
  subject(:coercer) do
    Class.new {
      include CoerceToLondonTime
    }.new
  end

  let(:london_time_zone) { ActiveSupport::TimeZone["Europe/London"] }

  describe "#coerce_to_london_time" do
    it "returns nil for nil" do
      expect(coercer.coerce_to_london_time(nil)).to be_nil
    end

    it "returns nil for a blank string" do
      expect(coercer.coerce_to_london_time("")).to be_nil
    end

    it "treats an ISO 8601 string as London-local, ignoring its Z suffix" do
      result = coercer.coerce_to_london_time("2026-09-23T09:00:00Z")

      expect(result).to eq(london_time_zone.local(2026, 9, 23, 9, 0, 0))
      expect(result.zone).to eq("BST")
    end

    it "treats an ISO 8601 string with an offset as London-local" do
      result = coercer.coerce_to_london_time("2026-09-23T09:00:00+00:00")

      expect(result).to eq(london_time_zone.local(2026, 9, 23, 9, 0, 0))
    end

    it "uses midnight for an ISO date-only string" do
      result = coercer.coerce_to_london_time("2026-12-23")

      expect(result).to eq(london_time_zone.local(2026, 12, 23))
      expect(result.zone).to eq("GMT")
    end

    it "preserves the displayed components of a Time object" do
      time = Time.utc(2026, 9, 23, 9, 0, 0)

      result = coercer.coerce_to_london_time(time)

      expect(result).to eq(london_time_zone.local(2026, 9, 23, 9, 0, 0))
    end

    it "preserves the displayed components of a TimeWithZone object" do
      utc_time = ActiveSupport::TimeZone["UTC"].local(2026, 9, 23, 9, 0, 0)

      result = coercer.coerce_to_london_time(utc_time)

      expect(result).to eq(london_time_zone.local(2026, 9, 23, 9, 0, 0))
    end

    # rubocop:disable Style/DateTime
    it "preserves the displayed components of a DateTime object" do
      date_time = DateTime.new(2026, 12, 23, 9, 0, 0, "+00:00")

      result = coercer.coerce_to_london_time(date_time)

      expect(result).to eq(london_time_zone.local(2026, 12, 23, 9, 0, 0))
    end
    # rubocop:enable Style/DateTime

    it "uses midnight for a Date object" do
      result = coercer.coerce_to_london_time(Date.new(2026, 12, 23))

      expect(result).to eq(london_time_zone.local(2026, 12, 23))
    end

    context "when winter time" do
      it "does not add daylight saving" do
        result = coercer.coerce_to_london_time(Time.utc(2026, 1, 6, 10, 30))
        expect(result).to eq(Time.new(2026, 1, 6, 10, 30, 0, "Z"))
      end
    end

    context "when summer time" do
      it "adds daylight saving" do
        result = coercer.coerce_to_london_time(Time.utc(2026, 7, 6, 10, 30))
        expect(result).to eq(Time.new(2026, 7, 6, 10, 30, 0, "+01:00"))
      end
    end

    it "raises an error for an invalid timestamp string" do
      expect {
        coercer.coerce_to_london_time("not a time")
      }.to raise_error(ArgumentError, 'Invalid timestamp: "not a time"')
    end

    it "raises an error for an unsupported type" do
      expect {
        coercer.coerce_to_london_time({ foo: :bar })
      }.to raise_error(
        ArgumentError,
        "Expected a Time, DateTime, Date, String; got Hash",
      )
    end
  end
end
