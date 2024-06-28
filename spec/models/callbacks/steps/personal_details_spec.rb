require "rails_helper"

describe Callbacks::Steps::PersonalDetails do
  include_context "with wizard step"
  it_behaves_like "a with wizard step"

  it { expect(described_class).to be < ::GITWizard::Steps::Identity }
end
