require "rails_helper"

describe EventsHelper, type: "helper" do
  let(:startdate) { DateTime.new(2020, 6, 1, 10) }
  let(:enddate) { DateTime.new(2020, 6, 1, 12) }
  let(:event) { build(:event_api, start_at: startdate, end_at: enddate) }

  describe "#format_event_date" do
    let(:stacked) { true }
    subject { format_event_date event, stacked: stacked }

    context "for single day event" do
      it { is_expected.to eql "June 1st, 2020 <br /> 10:00 - 12:00" }
    end

    context "for multi day event" do
      let(:enddate) { DateTime.new(2020, 6, 4, 14) }
      it { is_expected.to eql "June 1st, 2020 10:00 to June 4th, 2020 14:00" }
    end

    context "when not stacked" do
      let(:stacked) { false }

      it { is_expected.to eql "June 1st, 2020 at 10:00 - 12:00" }
    end
  end
end
