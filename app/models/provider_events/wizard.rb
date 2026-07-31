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
      Steps::EventDate,
      Steps::EventTimes,
      Steps::EventType,
      Steps::OnlinePostcode,
      Steps::InPersonLocation,
      Steps::NewVenue,
      Steps::RegistrationDetails,
      Steps::ReviewAnswers,
    ]
  end
end
