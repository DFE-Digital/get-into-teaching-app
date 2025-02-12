require "rails_helper"

RSpec.describe TeacherTrainingAdviser::Steps::ReturningTeacher do
  include_context "with a TTA wizard step"
  before do
    allow_any_instance_of(GetIntoTeachingApiClient::PickListItemsApi).to \
      receive(:get_contact_creation_channel_services).and_return(creation_channel_services)
  end

  let(:creation_channel_services) do
    [
      GetIntoTeachingApiClient::PickListItem.new({ id: 222_750_000, value: "CreatedOnApply" }),
      GetIntoTeachingApiClient::PickListItem.new({ id: 222_750_006, value: "Events" }),
      GetIntoTeachingApiClient::PickListItem.new({ id: 222_750_007, value: "MailingList" }),
      GetIntoTeachingApiClient::PickListItem.new({ id: 222_750_009, value: "ReturnToTeachingAdviserService" }),
      GetIntoTeachingApiClient::PickListItem.new({ id: 222_750_010, value: "TeacherTrainingAdviserService" }),
    ]
  end

  it_behaves_like "a with wizard step"

  describe "attributes" do
    it { is_expected.to respond_to :type_id }
    it { is_expected.to respond_to :creation_channel_service_id }
  end

  describe "#returning_to_teaching" do
    subject { instance.returning_to_teaching }

    context "when type_id is :returning_to_teaching" do
      before { instance.type_id = described_class::OPTIONS[:returning_to_teaching] }

      it { is_expected.to be_truthy }
    end

    context "when type_id is :interested_in_teaching" do
      before { instance.type_id = described_class::OPTIONS[:interested_in_teaching] }

      it { is_expected.to be_falsy }
    end
  end

  describe "#type_id" do
    it { is_expected.not_to allow_values("", nil, 123).for :type_id }
    it { is_expected.to allow_value(*described_class::OPTIONS.values).for :type_id }
  end

  describe "#reviewable_answers" do
    subject { instance.reviewable_answers }

    context "when returning to teaching" do
      before { instance.type_id = described_class::OPTIONS[:returning_to_teaching] }

      it { is_expected.to eq({ "returning_to_teaching" => "Yes" }) }
    end

    context "when interested in teaching" do
      before { instance.type_id = described_class::OPTIONS[:interested_in_teaching] }

      it { is_expected.to eq({ "returning_to_teaching" => "No" }) }
    end
  end

  describe "#save" do
    before do
      allow(instance).to receive(:other_step).with(:identity) {
        instance_double(TeacherTrainingAdviser::Steps::Identity, channel_id: channel_id, creation_channel_source_id: creation_channel_source_id)
      }
    end

    context "with legacy channel id" do
      let(:channel_id) { 222_750_027 }
      let(:creation_channel_source_id) { nil }

      it "does not set the creation_channel_service_id" do
        subject.save
        expect(subject.creation_channel_service_id).to be_nil
      end
    end

    context "with new creation channel ids" do
      let(:channel_id) { nil }
      let(:creation_channel_source_id) { 222_750_003 }

      it "sets the default creation_channel_service_id to TTA if they are new" do
        subject.type_id = 222_750_000
        subject.save
        expect(subject.creation_channel_service_id).to eq(222_750_010)
      end

      it "sets the default creation_channel_service_id to RTTA if they are returning" do
        subject.type_id = 222_750_001
        subject.save
        expect(subject.creation_channel_service_id).to eq(222_750_009)
      end

      it "preserves the creation_channel_service_id if already set" do
        subject.creation_channel_service_id = 222_750_007
        subject.save
        expect(subject.creation_channel_service_id).to eq(222_750_007)
      end
    end
  end
end
