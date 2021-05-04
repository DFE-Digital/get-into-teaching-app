require "attribute_filter"

module MailingList
  class Signup
    include ActiveModel::Model
    include ActiveModel::Attributes
    include ActiveModel::Validations::Callbacks
    include ::Wizard::ApiClientSupport

    attribute :accept_privacy_policy, :string
    attribute :accepted_policy_id, :string
    attribute :address_postcode, :string
    attribute :email, :string
    attribute :first_name, :string
    attribute :last_name, :string
    attribute :preferred_teaching_subject_id, :string

    attribute :channel_id, :integer
    attribute :consideration_journey_stage_id, :integer
    attribute :degree_status_id, :integer

    attribute :timed_one_time_password

    attribute :candidate_id
    attribute :qualification_id
    attribute :already_subscribed_to_mailing_list, :boolean

    before_validation :strip_whitespace

    validates :address_postcode,
              postcode: true

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

    validates :timed_one_time_password,
              on: :verify,
              presence: true,
              length: { is: 6, message: :invalid },
              format: { with: /\A[0-9]*\z/, message: :invalid }

    validate :timed_one_time_password_is_correct,
             on: :verify

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

    def export_data
      {
        "email" => email,
        "first_name" => first_name,
        "last_name" => last_name,
        "degree_status_id" => degree_status_id,
        "consideration_journey_stage_id" => consideration_journey_stage_id,
        "preferred_teaching_subject_id" => preferred_teaching_subject_id,
        "accepted_policy_id" => accepted_policy_id,
        "accept_privacy_policy" => accept_privacy_policy,
        "qualification_id" => qualification_id,
        "candidate_id" => candidate_id,
        "address_postcode" => address_postcode,
      }.compact
    end

    def latest_privacy_policy
      @latest_privacy_policy ||= GetIntoTeachingApiClient::PrivacyPoliciesApi.new.get_latest_privacy_policy
    end

    def add_member_to_mailing_list!
      request = GetIntoTeachingApiClient::MailingListAddMember.new(export_camelized_hash)
      Rails.logger.info("MailingList::Signup#add_mailing_list_member!: #{::AttributeFilter.filtered_json(request)}")
      api.add_mailing_list_member(request)
    end

    def exists_in_crm?
      request = GetIntoTeachingApiClient::ExistingCandidateRequest.new(identity_data)
      GetIntoTeachingApiClient::CandidatesApi.new.create_candidate_access_token(request)

      true
    rescue GetIntoTeachingApiClient::ApiError => e
      raise if e.code == 429

      Rails.logger.info("#{self.class} potential duplicate (response code #{e.code})") unless e.code == 404

      false
    end

  private

    def identity_data
      {
        "email" => email,
        "firstName" => first_name,
        "lastName" => last_name,
      }
    end

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

    def strip_whitespace
      email&.strip!
      first_name&.strip!
      last_name&.strip!
      timed_one_time_password&.strip!
      address_postcode&.strip!
    end

    def api
      GetIntoTeachingApiClient::MailingListApi.new
    end

    def timed_one_time_password_is_correct
      request = GetIntoTeachingApiClient::ExistingCandidateRequest.new(identity_data)
      response = api.exchange_access_token_for_mailing_list_add_member(timed_one_time_password, request)

      Rails.logger.info("MailingList::Wizard#exchange_access_token: #{AttributeFilter.filtered_json(response)}")

      response.tap do |r|
        self.candidate_id = r.candidate_id
        self.qualification_id = r.qualification_id
        self.already_subscribed_to_mailing_list = r.already_subscribed_to_mailing_list
      end
    rescue GetIntoTeachingApiClient::ApiError
      errors.add(:timed_one_time_password, :wrong_code)
    end
  end
end
