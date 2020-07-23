require "rails_helper"

describe EventsHelper, type: "helper" do
  let(:startdate) { DateTime.new(2020, 6, 1, 10) }
  let(:enddate) { DateTime.new(2020, 6, 1, 12) }
  let(:event) { build(:event_api, start_at: startdate, end_at: enddate) }

  describe "#format_event_date" do
    subject { format_event_date event }

    context "for single day event" do
      it { is_expected.to eql "1 June 2020 at 10:00 - 12:00" }
    end

    context "for multi day event" do
      let(:enddate) { DateTime.new(2020, 6, 4, 14) }
      it { is_expected.to eql "1 June 2020 10:00 to 4 June 2020 14:00" }
    end
  end
end
