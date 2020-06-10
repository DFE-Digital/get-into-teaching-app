require "rails_helper"

describe GetIntoTeachingApi::Event do
  include_examples "api support"

  let(:testdata) do
    build :event_api, eventName: "Become a teacher", startDate: "2020-05-18"
  end

  let(:event_id) { testdata["eventId"] }
  let(:apicall) { "teaching_events/#{event_id}" }

  let(:client) do
    described_class.new event_id: event_id, token: token, endpoint: endpoint
  end

  describe "#event" do
    it { is_expected.to be_kind_of GetIntoTeachingApi::Types::Event }
    it { is_expected.to respond_to :eventId }
    it { is_expected.to respond_to :eventName }
    it { is_expected.to respond_to :building }
    it { is_expected.to respond_to :room }
  end
end
