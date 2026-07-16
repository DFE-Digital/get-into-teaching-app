require "rails_helper"

RSpec.describe ProviderEvents::Steps::TargetAudience do
  include_context "with wizard step"

  it_behaves_like "a with wizard step"

  it { is_expected.to respond_to :target_audience }

  it { is_expected.to validate_presence_of :target_audience }

  it { is_expected.to validate_length_of(:target_audience).is_at_most(500) }

  it { is_expected.not_to be_skipped }
end
