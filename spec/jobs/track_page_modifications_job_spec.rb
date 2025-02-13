require "rails_helper"
require "page_modification_tracker"

RSpec.describe TrackPageModificationsJob, type: :job do
  describe "#perform" do
    let(:host) { "test.host" }
    let(:tracker) { instance_double(PageModificationTracker) }

    before do
      allow(PageModificationTracker).to receive(:new).with({ host: host }).and_return(tracker)
      allow(tracker).to receive(:track_page_modifications)
    end

    it "tracks page modifications with the provided host" do
      described_class.perform_now(host: host)
      expect(tracker).to have_received(:track_page_modifications)
    end

    it "requires a host parameter" do
      expect {
        described_class.new.perform
      }.to raise_error(ArgumentError, /missing keyword: :host/)
    end
  end
end
