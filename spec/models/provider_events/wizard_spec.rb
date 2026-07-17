require "rails_helper"

RSpec.describe ProviderEvents::Wizard do
  describe ".steps" do
    subject { described_class.steps }

    it {
      is_expected.to eql [
        ProviderEvents::Steps::Email,
        ProviderEvents::Steps::EventName,
        ProviderEvents::Steps::EventDescription,
        ProviderEvents::Steps::OrganisationName,
        ProviderEvents::Steps::EventWebsite,
        ProviderEvents::Steps::TargetAudience,
        ProviderEvents::Steps::EventDateTimes,
      ]
    }
  end
end
