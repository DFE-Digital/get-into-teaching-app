module Events
  module Steps
    class Authenticate < ::Wizard::Steps::Authenticate
    protected

      def perform_existing_candidate_request(request)
        @api ||= GetIntoTeachingApiClient::TeachingEventsApi.new
        @api.get_pre_filled_teaching_event_add_attendee(timed_one_time_password, request)
      end
    end
  end
end
