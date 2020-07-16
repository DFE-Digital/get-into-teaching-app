module Events
  class Wizard < ::Wizard::Base
    self.steps = [
      Steps::PersonalDetails,
      Steps::Authenticate,
      Steps::ContactDetails,
      Steps::FurtherDetails,
    ].freeze

    def complete!
      super.tap do |result|
        break unless result

        add_attendee_to_event
        @store.purge!
      end
    end

    def add_attendee_to_event
      request = GetIntoTeachingApiClient::TeachingEventAddAttendee.new(@store.to_hash)
      api = GetIntoTeachingApiClient::TeachingEventsApi.new
      api.add_teaching_event_attendee(request)
    end
  end
end
