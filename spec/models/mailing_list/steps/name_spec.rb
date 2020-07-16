require "rails_helper"

describe MailingList::Steps::Name do
  include_context "wizard step"
  it_behaves_like "a wizard step"

  it { is_expected.to respond_to :first_name }
  it { is_expected.to respond_to :last_name }
  it { is_expected.to respond_to :email }
  it { is_expected.to respond_to :current_status }

  context "validations" do
    subject { instance.tap(&:valid?).errors.messages }
    it { is_expected.to include(:first_name) }
    it { is_expected.to include(:last_name) }
    it { is_expected.to include(:email) }
    it { is_expected.to include(:current_status) }
  end

  context "email address" do
    it { is_expected.to allow_value("me@you.com").for :email }
    it { is_expected.to allow_value(" me@you.com ").for :email }
    it { is_expected.not_to allow_value("me@you").for :email }
  end

  context "current_status" do
    let(:statuses) { described_class.current_statuses }
    it { is_expected.to allow_value(statuses.first).for :current_status }
    it { is_expected.to allow_value(statuses.last).for :current_status }
    it { is_expected.not_to allow_value(nil).for :current_status }
    it { is_expected.not_to allow_value("").for :current_status }
    it { is_expected.not_to allow_value("random").for :current_status }
  end
end
