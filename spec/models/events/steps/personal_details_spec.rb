require "rails_helper"

describe Events::Steps::PersonalDetails do
  include_context "wizard step"
  it_behaves_like "a wizard step"

  it { is_expected.to respond_to :first_name }
  it { is_expected.to respond_to :last_name }
  it { is_expected.to respond_to :email_address }

  context "validations" do
    before { instance.valid? }
    subject { instance.errors.messages }
    it { is_expected.to include(:first_name) }
    it { is_expected.to include(:last_name) }
    it { is_expected.to include(:email_address) }
  end

  context "email address" do
    it { is_expected.to allow_value("me@you.com").for :email_address }
    it { is_expected.to allow_value(" me@you.com ").for :email_address }
    it { is_expected.not_to allow_value("me@you").for :email_address }
  end
end
