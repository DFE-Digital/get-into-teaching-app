module MailingList
  class Signup
    include ActiveModel::Model

    MATCHBACK_ATTRS = %i[candidate_id qualification_id].freeze

    attr_accessor :preferred_teaching_subject_id,
                  :consideration_journey_stage_id,
                  :accept_privacy_policy,
                  :address_postcode,
                  :first_name,
                  :last_name,
                  :email,
                  :channel_id,
                  :degree_status_id

    def degree_status_options
      @degree_status_options ||= query_degree_status
    end

    def teaching_subjects
      @teaching_subjects ||= [OpenStruct.new(id: nil, value: "Please select")] + query_teaching_subjects
    end

    def consideration_journey_stages
      @consideration_journey_stages ||= query_consideration_journey_stages
    end

  private

    def query_degree_status
      GetIntoTeachingApiClient::PickListItemsApi.new.get_qualification_degree_status
    end

    def query_teaching_subjects
      GetIntoTeachingApiClient::LookupItemsApi.new.get_teaching_subjects.reject do |type|
        GetIntoTeachingApiClient::Constants::IGNORED_PREFERRED_TEACHING_SUBJECTS.values.include?(type.id)
      end
    end

    def query_consideration_journey_stages
      GetIntoTeachingApiClient::PickListItemsApi.new.get_candidate_journey_stages
    end
  end
end
