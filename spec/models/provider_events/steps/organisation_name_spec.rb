require "rails_helper"

RSpec.describe ProviderEvents::Steps::OrganisationName do
  include_context "with wizard step"

  it_behaves_like "a with wizard step"

  it { is_expected.to respond_to :organisation_name }

  it { is_expected.to validate_presence_of :organisation_name }

  it { is_expected.to validate_length_of(:organisation_name).is_at_most(200) }

  it { is_expected.not_to be_skipped }
end
