require "rails_helper"

describe Feedback::Steps::Explanation do
  include_context "with wizard step"
  let(:wizard) { Feedback::Wizard.new(wizardstore, described_class.key) }

  it_behaves_like "a with wizard step"

  it { is_expected.to be_can_proceed }
  it { is_expected.to respond_to :explanation }
end
