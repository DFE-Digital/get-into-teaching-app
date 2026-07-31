require "rails_helper"

RSpec.describe ProviderEvents::Steps::EventDate do
  include_context "with wizard step"

  around do |example|
    freeze_time(&example)
  end

  it_behaves_like "a with wizard step"

  it { is_expected.not_to be_skipped }

  it { is_expected.to respond_to :event_date }
  it { is_expected.to validate_presence_of :event_date }
  it { is_expected.to validate_comparison_of(:event_date).is_greater_than_or_equal_to(Time.zone.today) }
end
