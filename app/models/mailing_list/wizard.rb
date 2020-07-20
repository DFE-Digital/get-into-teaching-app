module MailingList
  class Wizard < ::Wizard::Base
    self.steps = [
      Steps::Name,
      Steps::Authenticate,
      Steps::DegreeStage,
      Steps::TeacherTraining,
      Steps::Subject,
      Steps::Postcode,
      Steps::Contact,
    ].freeze

    def complete!
      super.tap do |result|
        break unless result

        add_member_to_mailing_list
        @store.purge!
      end
    end

    def add_member_to_mailing_list
      request = GetIntoTeachingApiClient::MailingListAddMember.new(@store.to_camelized_hash)
      api = GetIntoTeachingApiClient::MailingListApi.new
      api.add_mailing_list_member(request)
    end
  end
end
