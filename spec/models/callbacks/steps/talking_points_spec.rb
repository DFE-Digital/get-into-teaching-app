require "rails_helper"

describe Callbacks::Steps::TalkingPoints do
  include_context "wizard step"
  it_behaves_like "a wizard step"

  describe "attributes" do
    it { is_expected.to respond_to :talking_points }
  end

  describe "#talking_points" do
    it { is_expected.to_not allow_values(nil, "", "invalid value").for :talking_points }
    it { is_expected.to allow_values(described_class::OPTIONS).for :talking_points }
  end
end
