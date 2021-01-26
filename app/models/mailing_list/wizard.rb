module MailingList
  class Wizard < ::Wizard::Base
    include ::Wizard::ApiClientSupport

    self.steps = [
      Steps::Name,
      Steps::Authenticate,
      Steps::AlreadySubscribed,
      Steps::DegreeStatus,
      Steps::TeacherTraining,
      Steps::Subject,
      Steps::Postcode,
      Steps::PrivacyPolicy,
    ].freeze

    def complete!
      super.tap do |result|
        break unless result

        add_member_to_mailing_list
        @store.purge!
      end
    end

    def perform_auth_request(candidate_id, token)
      api = GetIntoTeachingApiClient::MailingListApi.new
      api.get_pre_filled_mailing_list_add_member_long_lived(candidate_id, token)
    end

  private

    def add_member_to_mailing_list
      request = GetIntoTeachingApiClient::MailingListAddMember.new(export_camelized_hash)
      api = GetIntoTeachingApiClient::MailingListApi.new
      api.add_mailing_list_member(request)
    end
  end
end

