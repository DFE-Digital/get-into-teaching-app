require "rails_helper"

describe Events::Steps::AccessibilityNeeds do
  include_context "with wizard step"

  before do
    allow(instance).to receive(:other_step).with(:accessibility_support) {
      instance_double(Events::Steps::AccessibilitySupport, no_support_required?: no_support_required)
    }
  end

  let(:no_support_required) { false }

  it_behaves_like "a with wizard step"

  it { is_expected.to respond_to :accessibility_needs_for_event }
  it { expect(subject).to be_required }

  describe "validations" do
    let(:very_long_sentence) { "A #{'very ' * 500}long sentence." }

    it { is_expected.not_to allow_values(nil, "").for :accessibility_needs_for_event }
    it { is_expected.to allow_values("Testing", "This is a sentence of text about accessibility needs.").for :accessibility_needs_for_event }
    it { is_expected.not_to allow_value(very_long_sentence).for :accessibility_needs_for_event }
    it { is_expected.to validate_length_of(:accessibility_needs_for_event).is_at_most(1000) }
  end

  describe "#skipped?" do
    subject { instance.skipped? }

    context "when support is required it should not be skipped" do
      let(:no_support_required) { false }

      it { is_expected.to be false }
    end

    context "when no support is required it should be skipped" do
      let(:no_support_required) { true }

      it { is_expected.to be true }
    end
  end
end
