module Events
  class Wizard < ::DFEWizard::Base
    include ::Wizard::ApiClientSupport

    self.steps = [
      Steps::PersonalDetails,
      Steps::Authenticate,
      Steps::ContactDetails,
      Steps::FurtherDetails,
      Steps::PersonalisedUpdates,
    ].freeze

    def complete!
      super.tap do |result|
        break unless result

        add_attendee_to_event
        @store.purge!
      end
    end

  private

    def add_attendee_to_event
      request = GetIntoTeachingApiClient::TeachingEventAddAttendee.new(export_camelized_hash)
      api = GetIntoTeachingApiClient::TeachingEventsApi.new
      api.add_teaching_event_attendee(request)
    end
  end
end
