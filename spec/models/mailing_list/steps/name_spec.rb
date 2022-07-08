require "rails_helper"

describe MailingList::Steps::Name do
  include_context "with wizard step"

  before do
    allow_any_instance_of(GetIntoTeachingApiClient::PickListItemsApi).to \
      receive(:get_candidate_mailing_list_subscription_channels).and_return(channels)
  end

  let(:channels) do
    OptionSet::MAILING_LIST_CHANNELS.map do |k, v|
      GetIntoTeachingApiClient::PickListItem.new({ id: v, value: k })
    end
  end

  it_behaves_like "a with wizard step"

  it { expect(described_class).to include(::GITWizard::IssueVerificationCode) }

  it { is_expected.to respond_to :first_name }
  it { is_expected.to respond_to :last_name }
  it { is_expected.to respond_to :email }

  describe "validations" do
    subject { instance.tap(&:valid?).errors.messages }

    it { is_expected.to include(:first_name) }
    it { is_expected.to include(:last_name) }
    it { is_expected.to include(:email) }
  end

  describe "validations for first_name" do
    it { is_expected.to validate_length_of(:first_name).is_at_most(256) }
  end

  describe "validations for last_name" do
    it { is_expected.to validate_length_of(:last_name).is_at_most(256) }
  end

  describe "validations for email address" do
    it { is_expected.to allow_value("me@you.com").for :email }
    it { is_expected.to allow_value(" me@you.com ").for :email }
    it { is_expected.not_to allow_value("me@you").for :email }
  end

  describe "#export" do
    subject { instance.export }

    %i[channel_id email first_name last_name].each do |key|
      it { is_expected.to have_key(key.to_s) }
    end

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
end
