require "rails_helper"

RSpec.describe TeacherTrainingAdviser::Steps::Identity do
  include_context "with a TTA wizard step"
  let(:channels) do
    [
      GetIntoTeachingApiClient::PickListItem.new({ id: 12_345, value: "Channel 1" }),
      GetIntoTeachingApiClient::PickListItem.new({ id: 67_890, value: "Channel 2" }),
    ]
  end

  before do
    allow_any_instance_of(GetIntoTeachingApiClient::PickListItemsApi).to \
      receive(:get_candidate_teacher_training_adviser_subscription_channels).and_return(channels)
  end

  it_behaves_like "a with wizard step"

  it { expect(described_class).to be < ::GITWizard::Steps::Identity }

  describe "attributes" do
    it { is_expected.to respond_to :channel_id }
    it { is_expected.to respond_to :sub_channel_id }
  end

  describe "#export" do
    subject { instance.export }

    it { is_expected.not_to have_key("sub_channel_id") }
  end

  describe "#save" do
    it "clears the channel_id on save when invalid" do
      subject.channel_id = "invalid"
      subject.save
      expect(subject.channel_id).to be_nil
    end

    it "retains the channel_id on save when valid" do
      subject.channel_id = channels.first.id
      subject.save
      expect(subject.channel_id).to eq(channels.first.id)
    end
  end

  describe "#reviewable_answers" do
    subject { instance.reviewable_answers }

    before do
      instance.channel_id = 1
      instance.sub_channel_id = "234"
    end

    it { is_expected.not_to have_key("channel_id") }
    it { is_expected.not_to have_key("sub_channel_id") }
  end
end
