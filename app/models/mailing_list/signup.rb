module MailingList
  class Signup
    include ActiveModel::Model
    include ActiveModel::Validations::Callbacks

    MATCHBACK_ATTRS = %i[candidate_id qualification_id].freeze

    attr_accessor :preferred_teaching_subject_id,
                  :consideration_journey_stage_id,
                  :accept_privacy_policy,
                  :accepted_policy_id,
                  :address_postcode,
                  :first_name,
                  :last_name,
                  :email,
                  :channel_id,
                  :degree_status_id

    before_validation :strip_whitespace

    validates :email,
              presence: true,
              email_format: true

    validates :first_name,
              presence: true,
              length: { maximum: 256 }

    validates :last_name,
              presence: true,
              length: { maximum: 256 }

    validates :channel_id,
              inclusion: { in: :channel_ids, allow_blank: true }

    validates :consideration_journey_stage_id,
              presence: true,
              inclusion: { in: :consideration_journey_stage_ids }

    validates :preferred_teaching_subject_id,
              presence: true,
              inclusion: { in: :teaching_subject_ids }

    validates :degree_status_id,
              presence: true,
              inclusion: { in: :degree_status_option_ids }

    validates :accept_privacy_policy,
              acceptance: true,
              allow_nil: false

    def degree_status_options
      @degree_status_options ||= query_degree_status
    end

    def teaching_subjects
      @teaching_subjects ||= [OpenStruct.new(id: nil, value: "Please select")] + query_teaching_subjects
    end

    def consideration_journey_stages
      @consideration_journey_stages ||= query_consideration_journey_stages
    end

    def query_channels
      @query_channels ||= GetIntoTeachingApiClient::PickListItemsApi.new.get_candidate_mailing_list_subscription_channels
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

    def consideration_journey_stage_ids
      consideration_journey_stages.map { |option| option.id.to_i }
    end

    def teaching_subject_ids
      teaching_subjects.map(&:id)
    end

    def degree_status_option_ids
      degree_status_options.map { |option| option.id.to_i }
    end

    def channel_ids
      query_channels.map { |channel| channel.id.to_i }
    end

    def latest_privacy_policy
      @latest_privacy_policy ||= GetIntoTeachingApiClient::PrivacyPoliciesApi.new.get_latest_privacy_policy
    end

    def strip_whitespace
      email&.strip!
      first_name&.strip!
      last_name&.strip!
    end
  end
end
