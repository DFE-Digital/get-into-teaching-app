require "rails_helper"

describe Events::Steps::PersonalDetails do
  include_context "with wizard step"
  it_behaves_like "a with wizard step"

  it { expect(described_class).to be < ::GITWizard::Steps::Identity }

  it { is_expected.to respond_to :is_walk_in }
  it { is_expected.to respond_to :event_id }
  it { is_expected.to respond_to :channel_ids }

  describe "event_id" do
    it { is_expected.to validate_presence_of(:event_id) }
  end

  describe "#is_walk_in?" do
    before { instance.is_walk_in = is_walk_in }

    context "when is_walk_in is nil" do
      let(:is_walk_in) { nil }

      it { is_expected.not_to be_is_walk_in }
    end

    context "when is_walk_in is false" do
      let(:is_walk_in) { false }

      it { is_expected.not_to be_is_walk_in }
    end

    context "when is_walk_in is true" do
      let(:is_walk_in) { true }

      it { is_expected.to be_is_walk_in }
    end
  end

  describe "#channel_ids" do
    it "returns an array of channel ids" do
      query_channels = [
        double(id: 1),
        double(id: 2),
        double(id: 3),
      ]
      allow(instance).to receive(:query_channels).and_return(query_channels)

      expect(instance.channel_ids).to eq([1, 2, 3])
    end
  end

  describe "#save" do
    shared_context "with query channels" do
      let(:query_channels) do
        [
          double(id: 1),
          double(id: 2),
          double(id: 3),
        ]
      end
      before { allow(instance).to receive(:query_channels).and_return(query_channels) }
    end

    context "when channel_id is invalid" do
      include_context "with query channels"
      before { instance.channel_id = 4 }

      it "sets channel_id to nil" do
        instance.save
        expect(instance.channel_id).to be_nil
      end
    end

    context "when channel_id is valid" do
      include_context "with query channels"
      before { instance.channel_id = 2 }

      it "does not change channel_id" do
        instance.save
        expect(instance.channel_id).to eq(2)
      end
    end
  end
end
