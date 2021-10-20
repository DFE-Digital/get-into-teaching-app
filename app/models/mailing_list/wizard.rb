require "attribute_filter"

module MailingList
  class Wizard < ::DFEWizard::Base
    include ::Wizard::ApiClientSupport

    self.steps = [
      Steps::Name,
      ::DFEWizard::Steps::Authenticate,
      Steps::AlreadySubscribed,
      Steps::DegreeStatus,
      Steps::TeacherTraining,
      Steps::Subject,
      Steps::Postcode,
      Steps::PrivacyPolicy,
    ].freeze

    def matchback_attributes
      %i[candidate_id qualification_id].freeze
    end

    def complete!
      super.tap do |result|
        break unless result

        add_member_to_mailing_list

        # we're taking the last name too so if people restart the wizard
        # both are filled rather than just their first name, which looks
        # a bit odd
        @store.prune!(leave: %w[first_name last_name])
      end
    end

    def exchange_access_token(timed_one_time_password, request)
      @api ||= GetIntoTeachingApiClient::MailingListApi.new
      response = @api.exchange_access_token_for_mailing_list_add_member(timed_one_time_password, request)
      Rails.logger.info("MailingList::Wizard#exchange_access_token: #{AttributeFilter.filtered_json(response)}")
      response
    end

  protected

    def exchange_magic_link_token(token)
      api = GetIntoTeachingApiClient::MailingListApi.new
      response = api.exchange_magic_link_token_for_mailing_list_add_member(token)
      Rails.logger.info("MailingList::Wizard#exchange_magic_link_token: #{AttributeFilter.filtered_json(response)}")
      response
    end

  private

    def add_member_to_mailing_list
      request = GetIntoTeachingApiClient::MailingListAddMember.new(export_camelized_hash)
      api = GetIntoTeachingApiClient::MailingListApi.new
      Rails.logger.info("MailingList::Wizard#add_mailing_list_member: #{AttributeFilter.filtered_json(request)}")
      api.add_mailing_list_member(request)
    end
  end
end
