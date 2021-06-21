require "rails_helper"

describe Callbacks::Steps::Callback do
  it_behaves_like "exposes callback booking quotas"
  include_context "wizard step"
  it_behaves_like "a wizard step"
  include_context "sanitize fields", %i[address_telephone]

  describe "attributes" do
    it { is_expected.to respond_to :phone_call_scheduled_at }
    it { is_expected.to respond_to :address_telephone }
  end

  describe "#phone_call_scheduled_at" do
    it { is_expected.to_not allow_values("", nil, "invalid_date").for :phone_call_scheduled_at }
    it { is_expected.to allow_value(Time.zone.now).for :phone_call_scheduled_at }
  end

  describe "#address_telephone" do
    it { is_expected.to_not allow_values(nil, "", "abc12345", "12", "1" * 21).for :address_telephone }
    it { is_expected.to allow_values("123456789").for :address_telephone }
  end
end
