require "rails_helper"

describe MailingList::Steps::Name do
  include_context "wizard step"
  it_behaves_like "a wizard step"

  let(:channels) do
    GetIntoTeachingApiClient::Constants::CANDIDATE_MAILING_LIST_SUBSCRIPTION_CHANNELS.map do |k, v|
      GetIntoTeachingApiClient::PickListItem.new({ id: v, value: k })
    end
  end

  before do
    allow_any_instance_of(GetIntoTeachingApiClient::PickListItemsApi).to \
      receive(:get_candidate_mailing_list_subscription_channels).and_return(channels)
  end

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

  describe "validations for channel_id" do
    let(:options) { channels.map(&:id) }

    it { is_expected.to allow_values(options).for :channel_id }
    it { is_expected.to allow_value(nil, "").for :channel_id }
    it { is_expected.not_to allow_value(12_345).for :channel_id }
  end

  context "when the step is valid" do
    it_behaves_like "an issue verification code wizard step"
  end
end
