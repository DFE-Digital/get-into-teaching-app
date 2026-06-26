module ProviderEvents
  class Wizard < ::GITWizard::Base
    DEFAULT_ERROR_MESSAGE = "Choose an option from the list".freeze

    self.steps = [
      Steps::Email,
      Steps::EventName,
      Steps::EventDescription,
      Steps::OrganisationName,
      Steps::EventWebsite,
      Steps::TargetAudience,
      # Steps::EventDates,
      # Steps::EventFormat,
      # Steps::EventRegion,
      # Steps::EventRegistration,
    ]
  end
end
