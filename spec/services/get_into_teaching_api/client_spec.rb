require "rails_helper"

describe GetIntoTeachingApi::Client do
  context "apicalls" do
    subject { described_class }
    it { is_expected.to respond_to :upcoming_events }
    it { is_expected.to respond_to :search_events }
    it { is_expected.to respond_to :event }
    it { is_expected.to respond_to :event_types }
  end

  context ".upcoming_events" do
    let(:apiclass) { GetIntoTeachingApi::UpcomingEvents }
    let(:upcoming) { double apiclass, call: [] }

    before do
      allow(apiclass).to receive(:new).and_return(upcoming)
    end

    subject! { described_class.upcoming_events }

    it "should instantiate an api call object" do
      expect(apiclass).to have_received(:new)
        .with(token: ENV["GIT_API_TOKEN"], endpoint: ENV["GIT_API_ENDPOINT"])
    end

    it "should call #call on instantiated class" do
      expect(upcoming).to have_received(:call)
    end
  end
end
