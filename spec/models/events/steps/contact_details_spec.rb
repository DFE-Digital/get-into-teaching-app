require "rails_helper"

describe Events::Steps::ContactDetails do
  include_context "wizard store"

  let(:instance) { described_class.new wizardstore }
  subject { instance }

  it_behaves_like "a wizard step"

  it { is_expected.to respond_to :phone_number }

  context "validations" do
    it { is_expected.to allow_value("").for :phone_number }
    it { is_expected.to allow_value("01234567890").for :phone_number }
    it { is_expected.to allow_value("01234 567890").for :phone_number }
    it { is_expected.not_to allow_value("invalid").for :phone_number }
    it { is_expected.not_to allow_value("01234").for :phone_number }
  end

  context "data cleaning" do
    subject { described_class.new wizardstore, phone_number: "  01234567890 " }
    before { subject.valid? }
    it { is_expected.to have_attributes phone_number: "01234567890" }
  end
end
