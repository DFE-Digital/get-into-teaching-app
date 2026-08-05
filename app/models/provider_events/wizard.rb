module ProviderEvents
  class Wizard < ::GITWizard::Base
    DEFAULT_ERROR_MESSAGE = "Choose an option from the list".freeze

    ATTRIBUTES_TO_LEAVE = %w[email reference_number].freeze

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

    def complete!
      super.tap do |result|
        break unless result

        Rails.logger.debug "@STORE.before: #{@store.inspect}"

        @store[:reference_number] = "COMING-SOON" # TODO: coming soon
        @store.prune!(leave: ATTRIBUTES_TO_LEAVE)

        Rails.logger.debug "@STORE.after: #{@store.inspect}"
      end
    end
  end
end
