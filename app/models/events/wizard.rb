require "attribute_filter"

module Events
  class Wizard < ::DFEWizard::Base
    include ::Wizard::ApiClientSupport

    self.steps = [
      Steps::PersonalDetails,
      ::Wizard::Steps::Authenticate,
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

    def exchange_access_token(timed_one_time_password, request)
      @api ||= GetIntoTeachingApiClient::TeachingEventsApi.new
      response = @api.exchange_access_token_for_teaching_event_add_attendee(timed_one_time_password, request)
      Rails.logger.info("Events::Wizard#exchange_access_token: #{AttributeFilter.filtered_json(response)}")
      response
    end

    def exchange_unverified_request(request)
      super unless find(Steps::PersonalDetails.key).is_walk_in?

      @api ||= GetIntoTeachingApiClient::TeachingEventsApi.new
      response = @api.exchange_unverified_request_for_teaching_event_add_attendee(request)
      Rails.logger.info("Events::Wizard#exchange_unverified_request: #{AttributeFilter.filtered_json(response)}")
      response
    end

  private

    def add_attendee_to_event
      request = GetIntoTeachingApiClient::TeachingEventAddAttendee.new(export_camelized_hash)
      api = GetIntoTeachingApiClient::TeachingEventsApi.new
      Rails.logger.info("Events::Wizard#add_attendee_to_event: #{AttributeFilter.filtered_json(request)}")
      api.add_teaching_event_attendee(request)
    end
  end
end
