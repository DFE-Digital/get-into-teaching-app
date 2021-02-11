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

  protected

    def exchange_magic_link_token(token)
      api = GetIntoTeachingApiClient::MailingListApi.new
      api.exchange_magic_link_token_for_mailing_list_add_member(token)
    end

  private

    def add_member_to_mailing_list
      request = GetIntoTeachingApiClient::MailingListAddMember.new(export_camelized_hash)
      api = GetIntoTeachingApiClient::MailingListApi.new
      api.add_mailing_list_member(request)
    end
  end
end
