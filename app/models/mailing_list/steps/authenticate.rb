module MailingList
  module Steps
    class Authenticate < ::Wizard::Steps::Authenticate
    protected

      def perform_existing_candidate_request(request)
        @api ||= GetIntoTeachingApiClient::MailingListApi.new
        @api.exchange_access_token_for_mailing_list_add_member(timed_one_time_password, request)
      end
    end
  end
end
