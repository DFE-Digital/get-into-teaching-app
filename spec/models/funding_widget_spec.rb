require "rails_helper"

describe FundingWidget do
  describe "attributes" do
    it { is_expected.to respond_to :subject }
  end

  describe "validations" do
    describe "#subject" do
      it { is_expected.to allow_value("test").for :subject }
      it { is_expected.not_to allow_values("", nil).for :subject }
    end
  end
end
