require "rails_helper"

describe MailingList::Steps::Name do
  include_context "wizard step"
  it_behaves_like "a wizard step"

  let(:describe_yourself_option_types) do
    GetIntoTeachingApi::Constants::DESCRIBE_YOURSELF_OPTIONS.map do |k, v|
      GetIntoTeachingApiClient::TypeEntity.new({ id: v, value: k })
    end
  end

  before do
    allow_any_instance_of(GetIntoTeachingApiClient::TypesApi).to \
      receive(:get_candidate_describe_yourself_options).and_return(describe_yourself_option_types)
  end

  it { is_expected.to respond_to :first_name }
  it { is_expected.to respond_to :last_name }
  it { is_expected.to respond_to :email }
  it { is_expected.to respond_to :describe_yourself_option_id }

  context "validations" do
    subject { instance.tap(&:valid?).errors.messages }
    it { is_expected.to include(:first_name) }
    it { is_expected.to include(:last_name) }
    it { is_expected.to include(:email) }
    it { is_expected.to include(:describe_yourself_option_id) }
  end

  context "email address" do
    it { is_expected.to allow_value("me@you.com").for :email }
    it { is_expected.to allow_value(" me@you.com ").for :email }
    it { is_expected.not_to allow_value("me@you").for :email }
  end

  context "describe_yourself_option_id" do
    let(:options) { describe_yourself_option_types.map(&:id) }
    it { is_expected.to allow_value(options.first).for :describe_yourself_option_id }
    it { is_expected.to allow_value(options.last).for :describe_yourself_option_id }
    it { is_expected.not_to allow_value(nil).for :describe_yourself_option_id }
    it { is_expected.not_to allow_value("").for :describe_yourself_option_id }
    it { is_expected.not_to allow_value("random").for :describe_yourself_option_id }
  end
end
