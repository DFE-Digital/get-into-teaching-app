require "rails_helper"

describe MailingList::Steps::Name do
  include_context "wizard step"
  it_behaves_like "a wizard step"

  let(:degree_status_option_types) do
    GetIntoTeachingApi::Constants::DEGREE_STATUS_OPTIONS.map do |k, v|
      GetIntoTeachingApiClient::TypeEntity.new({ id: v, value: k })
    end
  end

  before do
    allow_any_instance_of(GetIntoTeachingApiClient::TypesApi).to \
      receive(:get_qualification_degree_status).and_return(degree_status_option_types)
  end

  it { is_expected.to respond_to :first_name }
  it { is_expected.to respond_to :last_name }
  it { is_expected.to respond_to :email }
  it { is_expected.to respond_to :degree_status_id }

  context "validations" do
    subject { instance.tap(&:valid?).errors.messages }
    it { is_expected.to include(:first_name) }
    it { is_expected.to include(:last_name) }
    it { is_expected.to include(:email) }
    it { is_expected.to include(:degree_status_id) }
  end

  context "email address" do
    it { is_expected.to allow_value("me@you.com").for :email }
    it { is_expected.to allow_value(" me@you.com ").for :email }
    it { is_expected.not_to allow_value("me@you").for :email }
  end

  context "degree_status_id" do
    let(:options) { degree_status_option_types.map(&:id) }
    it { is_expected.to allow_value(options.first).for :degree_status_id }
    it { is_expected.to allow_value(options.last).for :degree_status_id }
    it { is_expected.not_to allow_value(nil).for :degree_status_id }
    it { is_expected.not_to allow_value("").for :degree_status_id }
    it { is_expected.not_to allow_value(12_345).for :degree_status_id }
  end

  context "when the step is valid" do
    subject do
      instance.tap do |step|
        step.degree_status_id = degree_status_option_types.first.id
      end
    end

    it_behaves_like "an issue verification code wizard step"
  end
end
