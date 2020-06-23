require "rails_helper"

describe EventsHelper, type: "helper" do
  let(:eventdata) { build(:event_api).merge dates }
  let(:event) { GetIntoTeachingApi::Types::Event.new eventdata }

  describe "#format_event_date" do
    subject { format_event_date event }

    context "for single day event" do
      let(:dates) { { "startDate" => "2020-06-01", "endDate" => "2020-06-01" } }
      it { is_expected.to eql "1st June 2020" }
    end

    context "for multi day event" do
      let(:dates) { { "startDate" => "2020-06-01", "endDate" => "2020-06-04" } }
      it { is_expected.to eql "1st June 2020 to 4th June 2020" }
    end
  end
end
