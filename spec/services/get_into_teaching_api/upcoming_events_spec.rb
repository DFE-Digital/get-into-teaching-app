require "rails_helper"

describe GetIntoTeachingApi::UpcomingEvents do
  include_examples "api support"
  let(:event_id) { SecureRandom.uuid }
  let(:building_id) { SecureRandom.uuid }
  let(:room_id) { SecureRandom.uuid }
  let(:apicall) { "teaching_events/upcoming" }
  let(:testdata) { build_list :event_api, 1, startDate: "2020-05-18" }

  describe "#events" do
    it { is_expected.to be_kind_of Array }
    it { is_expected.to have_attributes length: 1 }
    it { is_expected.to all respond_to :eventId }
    it { is_expected.to all respond_to :eventName }

    context "event details" do
      subject { client.call.first }
      it { is_expected.to be_kind_of GetIntoTeachingApi::Types::Event }
      it { is_expected.to have_attributes eventId: testdata[0]["eventId"] }
      it { is_expected.to have_attributes eventName: testdata[0]["eventName"] }
      it { is_expected.to have_attributes startDate: Date.parse("2020-05-18") }
      it { is_expected.to have_attributes endDate: Date.parse("2020-05-18") }
    end

    context "event building" do
      subject { client.call.first.building }
      it { is_expected.to be_kind_of GetIntoTeachingApi::Types::EventBuilding }
      it { is_expected.to have_attributes id: testdata[0]["building"]["id"] }
      it { is_expected.to have_attributes addressComposite: "Line 1, Line 2" }
    end

    context "event room" do
      subject { client.call.first.room }
      it { is_expected.to be_kind_of GetIntoTeachingApi::Types::EventRoom }
      it { is_expected.to have_attributes id: testdata[0]["room"]["id"] }
      it { is_expected.to have_attributes description: "Lecture Hall 1 description" }
    end
  end
end
