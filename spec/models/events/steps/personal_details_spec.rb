require "rails_helper"

describe Events::Steps::PersonalDetails do
  include_context "wizard step"
  it_behaves_like "a wizard step"
  it_behaves_like "an issue verification code wizard step"

  it { is_expected.to respond_to :first_name }
  it { is_expected.to respond_to :last_name }
  it { is_expected.to respond_to :email }

  describe "validations" do
    before { instance.valid? }
    subject { instance.errors.messages }
    it { is_expected.to include(:first_name) }
    it { is_expected.to include(:last_name) }
    it { is_expected.to include(:email) }
  end

  describe "#first_name" do
    it { is_expected.to validate_length_of(:first_name).is_at_most(256) }
  end

  describe "#last_name" do
    it { is_expected.to validate_length_of(:last_name).is_at_most(256) }
  end

  describe "#email address" do
    it { is_expected.to allow_value("me@you.com").for :email }
    it { is_expected.to allow_value(" me@you.com ").for :email }
    it { is_expected.not_to allow_value("me@you").for :email }
  end
end
