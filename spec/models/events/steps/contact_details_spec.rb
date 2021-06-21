require "rails_helper"

describe Events::Steps::ContactDetails do
  include_context "wizard step"

  it_behaves_like "a wizard step"

  it { is_expected.to respond_to :address_telephone }
  it { expect(subject).to be_optional }

  describe "validations" do
    it { is_expected.to allow_value("").for :address_telephone }
    it { is_expected.to allow_value("01234567890").for :address_telephone }
    it { is_expected.to allow_value("01234 567890").for :address_telephone }
    it { is_expected.not_to allow_value("invalid").for :address_telephone }
    it { is_expected.not_to allow_value("1234").for :address_telephone }
  end

  describe "data cleaning" do
    it "cleans the telephone" do
      subject.address_telephone = "  01234567890 "
      subject.valid?
      expect(subject.address_telephone).to eq("01234567890")
      subject.address_telephone = "  "
      subject.valid?
      expect(subject.address_telephone).to be_nil
    end
  end
end
