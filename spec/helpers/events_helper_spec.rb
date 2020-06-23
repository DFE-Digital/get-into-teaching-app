require "rails_helper"

describe EventsHelper, type: "helper" do
  let(:startdate) { "2020-06-01" }
  let(:enddate) { startdate }
  let(:eventdata) do
    build(:event_api).merge("startDate" => startdate, "endDate" => enddate)
  end
  let(:event) { GetIntoTeachingApi::Types::Event.new eventdata }

  describe "#format_event_date" do
    subject { format_event_date event }

    context "for single day event" do
      it { is_expected.to eql "1st June 2020" }
    end

    context "for multi day event" do
      let(:enddate) { "2020-06-04" }
      it { is_expected.to eql "1st June 2020 to 4th June 2020" }
    end
  end
end
