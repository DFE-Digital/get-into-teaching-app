require "rails_helper"

RSpec.describe ProviderEvents::Steps::Email do
  include_context "with wizard step"

  it_behaves_like "a with wizard step"

  it { is_expected.to respond_to :email }

  it { is_expected.to validate_presence_of :email }

  it { is_expected.to validate_length_of(:email).is_at_most(254) }

  it { is_expected.not_to be_skipped }
end
