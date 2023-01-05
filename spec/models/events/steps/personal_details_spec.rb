require "rails_helper"

describe Events::Steps::PersonalDetails do
  include_context "with wizard step"
  it_behaves_like "a with wizard step"

  it { expect(described_class).to be < ::GITWizard::Steps::Identity }

  it { is_expected.to respond_to :is_walk_in }
  it { is_expected.to respond_to :event_id }

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
end
