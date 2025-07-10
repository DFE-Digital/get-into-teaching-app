require "attribute_filter"
require "digest"

module MailingList
  class Wizard < ::GITWizard::Base
    ATTRIBUTES_TO_LEAVE = %w[
      first_name
      last_name
      preferred_teaching_subject_id
      situation
      consideration_journey_stage_id
      degree_status_id
      sub_channel_id
      hashed_email
      graduation_year
      inferred_degree_status
    ].freeze

    self.steps = [
      Steps::Name,
      Steps::Authenticate,
      Steps::AlreadySubscribed,
      Steps::ReturningTeacher,
      Steps::AlreadyQualified,
      Steps::DegreeStatus,
      Steps::LifeStage,
      Steps::TeacherTraining,
      Steps::Subject,
      Steps::Postcode,
    ].freeze

    def matchback_attributes
      %i[candidate_id qualification_id].freeze
    end

    def complete!
      super.tap do |result|
        break unless result

        @store[:inferred_degree_status] = add_member_to_mailing_list
        @store[:hashed_email] = Digest::SHA256.hexdigest(@store[:email]) if @store[:email].present?

        # we're taking the last name too so if people restart the wizard
        # both are filled rather than just their first name, which looks
        # a bit odd
        @store.prune!(leave: ATTRIBUTES_TO_LEAVE)
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
      request = GetIntoTeachingApiClient::MailingListAddMember.new(construct_export)
      api = GetIntoTeachingApiClient::MailingListApi.new
      Rails.logger.info("MailingList::Wizard#add_mailing_list_member: #{AttributeFilter.filtered_json(request)}")
      response = api.add_mailing_list_member(request, { return_type: "json" })

      Crm::OptionSet.lookup_by_value(:legacy_degree_status_for_advertising, response.degree_status_id)
    end

    def construct_export
      attributes = GetIntoTeachingApiClient::MailingListAddMember.attribute_map.keys
      export_data.slice(*attributes.map(&:to_s))
    end
  end
end
