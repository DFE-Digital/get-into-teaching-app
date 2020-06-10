require "rails_helper"

describe Events::Steps::PersonalDetails do
  include_context "wizard store"

  let(:instance) { described_class.new wizardstore }
  subject { instance }

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
end
