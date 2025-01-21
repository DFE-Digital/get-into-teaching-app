require "rails_helper"

describe Events::Steps::PersonalDetails do
  include_context "with wizard step"
  before do
    allow_any_instance_of(GetIntoTeachingApiClient::PickListItemsApi).to \
      receive(:get_candidate_event_subscription_channels).and_return(legacy_channels)
    allow_any_instance_of(GetIntoTeachingApiClient::PickListItemsApi).to \
      receive(:get_contact_creation_channel_services).and_return(creation_channel_services)
    allow_any_instance_of(GetIntoTeachingApiClient::PickListItemsApi).to \
      receive(:get_contact_creation_channel_sources).and_return(creation_channel_sources)
    allow_any_instance_of(GetIntoTeachingApiClient::PickListItemsApi).to \
      receive(:get_contact_creation_channel_activities).and_return(creation_channel_activities)
  end

  let(:creation_channel_activities) do
    [
      GetIntoTeachingApiClient::PickListItem.new({ id: 222_750_000, value: "BrandAmbassadorActivity" }),
      GetIntoTeachingApiClient::PickListItem.new({ id: 222_750_010, value: "222750010" }),
      GetIntoTeachingApiClient::PickListItem.new({ id: 222_750_021, value: "StudentUnionMedia" }),
    ]
  end
  let(:creation_channel_services) do
    [
      GetIntoTeachingApiClient::PickListItem.new({ id: 222_750_000, value: "CreatedOnApply" }),
      GetIntoTeachingApiClient::PickListItem.new({ id: 222_750_006, value: "Events" }),
      GetIntoTeachingApiClient::PickListItem.new({ id: 222_750_007, value: "MailingList" }),
      GetIntoTeachingApiClient::PickListItem.new({ id: 222_750_008, value: "PaidSearch" }),
    ]
  end
  let(:creation_channel_sources) do
    [
      GetIntoTeachingApiClient::PickListItem.new({ id: 222_750_000, value: "Apply" }),
      GetIntoTeachingApiClient::PickListItem.new({ id: 222_750_003, value: "GITWebsite" }),
      GetIntoTeachingApiClient::PickListItem.new({ id: 222_750_009, value: "PaidAdvertising" }),
    ]
  end
  let(:legacy_channels) do
    [
      GetIntoTeachingApiClient::PickListItem.new({ id: 222_750_028, value: "MailingList" }),
      GetIntoTeachingApiClient::PickListItem.new({ id: 222_750_029, value: "Event" }),
      GetIntoTeachingApiClient::PickListItem.new({ id: 222_750_027, value: "TeacherTrainingAdviser" }),
    ]
  end

  it_behaves_like "a with wizard step"

  it { expect(described_class).to be < ::GITWizard::Steps::Identity }

  it { is_expected.to respond_to :is_walk_in }
  it { is_expected.to respond_to :event_id }
  it { is_expected.to respond_to :channel_id }
  it { is_expected.to respond_to :creation_channel_source_id }
  it { is_expected.to respond_to :creation_channel_service_id }
  it { is_expected.to respond_to :creation_channel_activity_id }

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

  describe "#export" do
    it "does not include sub_channel_id" do
      expect(instance.export).not_to include("sub_channel_id")
    end
  end

  describe "#save" do
    context "with legacy channel id" do
      it "clears the legacy channel_id on save when invalid" do
        subject.channel_id = "invalid"
        subject.save
        expect(subject.channel_id).to be_nil
        expect(subject.creation_channel_source_id).to eq(222_750_003)
        expect(subject.creation_channel_service_id).to eq(222_750_006)
        expect(subject.creation_channel_activity_id).to be_nil
      end

      it "retains the legacy channel_id on save when present and valid" do
        subject.channel_id = legacy_channels.first.id
        subject.save
        expect(subject.channel_id).to eq(legacy_channels.first.id)
        expect(subject.creation_channel_source_id).to be_nil
        expect(subject.creation_channel_service_id).to be_nil
        expect(subject.creation_channel_activity_id).to be_nil
      end
    end

    context "with new creation channel ids" do
      it "clears the legacy channel id and preserves the new creation channel ids" do
        subject.channel_id = legacy_channels.first.id
        subject.creation_channel_source_id = creation_channel_sources.first.id
        subject.creation_channel_service_id = creation_channel_services.first.id
        subject.creation_channel_activity_id = creation_channel_activities.first.id
        subject.save
        expect(subject.channel_id).to be_nil
        expect(subject.creation_channel_source_id).to eq(creation_channel_sources.first.id)
        expect(subject.creation_channel_service_id).to eq(creation_channel_services.first.id)
        expect(subject.creation_channel_activity_id).to eq(creation_channel_activities.first.id)
      end

      it "sets the default creation channel ids if not present" do
        subject.channel_id = nil
        subject.creation_channel_source_id = nil
        subject.creation_channel_service_id = nil
        subject.creation_channel_activity_id = nil
        subject.save
        expect(subject.channel_id).to be_nil
        expect(subject.creation_channel_source_id).to eq(222_750_003)
        expect(subject.creation_channel_service_id).to eq(222_750_006)
        expect(subject.creation_channel_activity_id).to be_nil
      end

      it "sets the default creation channel ids if not valid" do
        subject.channel_id = 1
        subject.creation_channel_source_id = 2
        subject.creation_channel_service_id = 3
        subject.creation_channel_activity_id = 4
        subject.save
        expect(subject.channel_id).to be_nil
        expect(subject.creation_channel_source_id).to eq(222_750_003)
        expect(subject.creation_channel_service_id).to eq(222_750_006)
        expect(subject.creation_channel_activity_id).to be_nil
      end
    end
  end
end
