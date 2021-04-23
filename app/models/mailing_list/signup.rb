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
  end
end
