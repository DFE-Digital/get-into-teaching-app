module MailingList
  module Steps
    class Authenticate < ::Wizard::Steps::Authenticate
    protected

      def perform_existing_candidate_request(request)
        @api ||= GetIntoTeachingApiClient::MailingListApi.new
        @api.get_pre_filled_mailing_list_add_member(timed_one_time_password, request)
      end
    end
  end
end
