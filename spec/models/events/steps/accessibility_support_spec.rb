require "rails_helper"

describe Events::Steps::AccessibilitySupport do
  include_context "with wizard step"

  it_behaves_like "a with wizard step"

  it { is_expected.to respond_to :support_required }
  it { expect(subject).to be_required }

  describe "validations" do
    it { is_expected.not_to allow_values(nil, 123).for :support_required }
    it { is_expected.to allow_values(*Events::Steps::AccessibilitySupport::OPTIONS.values).for :support_required }
  end

  describe "#no_support_required?" do
    subject { instance.no_support_required? }

    context "when NO" do
      before { instance.support_required = described_class::NO }

      it { is_expected.to be true }
    end

    context "when YES" do
      before { instance.support_required = described_class::YES }

      it { is_expected.to be false }
    end
  end
end
