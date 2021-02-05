module Events
  module Steps
    class Authenticate < ::Wizard::Steps::Authenticate
    protected

      def perform_existing_candidate_request(request)
        @api ||= GetIntoTeachingApiClient::TeachingEventsApi.new
        @api.exchange_access_token_for_teaching_event_add_attendee(timed_one_time_password, request)
      end
    end
  end
end
