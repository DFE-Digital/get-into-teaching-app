require "rails_helper"

describe GetIntoTeachingApi::UpcomingEvents do
  include_examples "api support"
  let(:event_id) { SecureRandom.uuid }
  let(:building_id) { SecureRandom.uuid }
  let(:room_id) { SecureRandom.uuid }
  let(:apicall) { "teaching_events/upcoming" }
  let(:testdata) { build_list :event_api, 1 }

  describe "#events" do
    it_behaves_like "array of event entities", 1

    describe "first entity" do
      let(:eventdata) { testdata[0] }
      let(:event) { client.call.first }
      it_behaves_like "event entity"
    end
  end
end
