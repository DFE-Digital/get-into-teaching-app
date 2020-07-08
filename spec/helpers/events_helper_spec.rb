require "rails_helper"

describe EventsHelper, type: "helper" do
  let(:startdate) { "2020-06-01T10:00:00" }
  let(:enddate) { "2020-06-01T12:00:00" }
  let(:eventdata) do
    build(:event_api).merge("startAt" => startdate, "endAt" => enddate)
  end
  let(:event) { GetIntoTeachingApi::Types::Event.new eventdata }

  describe "#format_event_date" do
    subject { format_event_date event }

    context "for single day event" do
      it { is_expected.to eql "1 June 2020 at 10:00 - 12:00" }
    end

    context "for multi day event" do
      let(:enddate) { "2020-06-04T14:00:00" }
      it { is_expected.to eql "1 June 2020 10:00 to 4 June 2020 14:00" }
    end
  end
end
