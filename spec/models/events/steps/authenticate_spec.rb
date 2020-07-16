require "rails_helper"

describe Events::Steps::Authenticate do
  include_context "wizard step"
  it_behaves_like "a wizard step"

  it { is_expected.to respond_to :timed_one_time_password }

  context "validations" do
    before { instance.valid? }
    subject { instance.errors.messages }
    it { is_expected.to include(:timed_one_time_password) }
  end

  context "timed one time password" do
    it { is_expected.to allow_value("000000").for :timed_one_time_password }
    it { is_expected.to allow_value(" 123456").for :timed_one_time_password }
    it { is_expected.not_to allow_value("abc123").for :timed_one_time_password }
    it { is_expected.not_to allow_value("1234567").for :timed_one_time_password }
    it { is_expected.not_to allow_value("12345").for :timed_one_time_password }
  end

  describe "skipped?" do
    it "returns true if authenticate is false" do
      wizardstore["authenticate"] = false
      expect(subject).to be_skipped
    end

    it "returns false if authenticate is true" do
      wizardstore["authenticate"] = true
      expect(subject).to_not be_skipped
    end
  end
end
