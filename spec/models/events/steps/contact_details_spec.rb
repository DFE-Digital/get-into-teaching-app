require "rails_helper"

describe Events::Steps::ContactDetails do
  include_context "wizard step"

  it_behaves_like "a wizard step"

  it { is_expected.to respond_to :telephone }

  describe "validations" do
    it { is_expected.to allow_value("").for :telephone }
    it { is_expected.to allow_value("01234567890").for :telephone }
    it { is_expected.to allow_value("01234 567890").for :telephone }
    it { is_expected.not_to allow_value("invalid").for :telephone }
    it { is_expected.not_to allow_value("01234").for :telephone }
  end

  describe "data cleaning" do
    it "cleans the telephone" do
      subject.telephone = "  01234567890 "
      subject.valid?
      expect(subject.telephone).to eq("01234567890")
      subject.telephone = "  "
      subject.valid?
      expect(subject.telephone).to be_nil
    end
  end
end
