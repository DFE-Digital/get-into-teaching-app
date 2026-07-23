require "rails_helper"

RSpec.describe ProviderEvents::Steps::EventName do
  include_context "with wizard step"

  it_behaves_like "a with wizard step"

  it { is_expected.to respond_to :event_name }

  it { is_expected.to validate_presence_of :event_name }

  it { is_expected.to validate_length_of(:event_name).is_at_most(200) }

  it { is_expected.not_to be_skipped }
end
