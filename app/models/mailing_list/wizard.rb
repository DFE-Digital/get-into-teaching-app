require "attribute_filter"

module MailingList
  class Wizard < ::GITWizard::Base
    ATTRIBUTES_TO_LEAVE = %w[
      first_name
      last_name
      preferred_teaching_subject_id
      consideration_journey_stage_id
      degree_status_id
      sub_channel_id
    ].freeze

    self.steps = [
      Steps::Name,
      ::GITWizard::Steps::Authenticate,
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
      api.add_mailing_list_member(request)
    end

    def construct_export
      attributes = GetIntoTeachingApiClient::MailingListAddMember.attribute_map.keys
      export = export_data.slice(*attributes.map(&:to_s))

      show_welcome_guide = ApplicationController.helpers.show_welcome_guide?(
        degree_status: export["degree_status_id"],
        consideration_journey_stage: export["consideration_journey_stage_id"],
      )

      return export unless show_welcome_guide

      wg_params = export_data
        .slice("degree_status_id", "preferred_teaching_subject_id")
        .symbolize_keys

      export.tap { |h| h[:welcome_guide_variant] = welcome_guide_variant(**wg_params) }
    end

    def welcome_guide_variant(degree_status_id: nil, preferred_teaching_subject_id: nil)
      %w[/email].tap { |path|
        if preferred_teaching_subject_id
          path << ["subject", TeachingSubject.lookup_by_uuid(preferred_teaching_subject_id).parameterize(separator: "_")]
        end

        if degree_status_id
          path << ["degree-status", OptionSet.lookup_by_value(:degree_status, degree_status_id).downcase]
        end
      }.join("/")
    end
  end
end
