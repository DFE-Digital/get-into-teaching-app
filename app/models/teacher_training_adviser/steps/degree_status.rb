module TeacherTrainingAdviser::Steps
  class DegreeStatus < GITWizard::Step
    HAS_DEGREE = 222_750_000
    DEGREE_IN_PROGRESS = 222_750_006
    NO_DEGREE = 222_750_004

    GRADUATION_MONTH = 8
    GRADUATION_DAY = 31

    attribute :degree_status_id, :integer
    attribute :graduation_year, :integer
    attribute :creation_channel_service_id, :integer

    validates :degree_status_id,
              presence: { message: "Choose a degree option from the list" },
              inclusion: { in: :degree_status_option_ids }

    validates :graduation_year,
              format: {
                with: /\A\d{4}\z/,
                message: "Enter your expected graduation year",
              },
              numericality: { only_integer: true },
              presence: { message: "Enter your expected graduation year" },
              if: :degree_in_progress?

    validate :graduation_year_not_in_the_past, if: :degree_in_progress?
    validate :graduation_year_not_too_far_in_the_future, if: :degree_in_progress?

    include FunnelTitle

    def save
      super

      if reset_creation_channel_service_id?
        # set the creation_channel_service_id based on degree status: final years follow the TTA whereas earlier years follow ETA
        self.creation_channel_service_id = studying_final_year? ? ReturningTeacher::TTA_DEFAULT_CREATION_CHANNEL_SERVICE_ID : ReturningTeacher::ETA_DEFAULT_CREATION_CHANNEL_SERVICE_ID
      end
      super
    end

    def degree_status_options
      @degree_status_options ||= PickListItemsApiPresenter.new.get_qualification_degree_status
    end

    def degree_status_option_ids
      degree_status_options.map { |option| option.id.to_i }
    end

    def reviewable_answers
      if degree_in_progress?
        {
          "degree_status_id" => degree_status_id ? I18n.t("helpers.answer.teacher_training_adviser_steps.degree_status.degree_status_id.#{degree_status_id}", **Value.data) : nil,
          "graduation_year" => graduation_year,
        }
      else
        {
          "degree_status_id" => degree_status_id ? I18n.t("helpers.answer.teacher_training_adviser_steps.degree_status.degree_status_id.#{degree_status_id}", **Value.data) : nil,
        }
      end
    end

    def skipped?
      other_step(:returning_teacher).returning_to_teaching
    end

    def has_degree?
      degree_status_id == HAS_DEGREE
    end

    def degree_in_progress?
      degree_status_id == DEGREE_IN_PROGRESS
    end

    def no_degree?
      degree_status_id == NO_DEGREE
    end

    def studying_first_year?
      # we are in the first year if there are more than than 2 years to go to graduation
      degree_in_progress? &&
        graduation_year.present? &&
        (today <= (graduation_date - 2.years))
    end

    def studying_final_year?
      # we are in the final year if there is less than 1 year to go to graduation
      degree_in_progress? &&
        graduation_year.present? &&
        (today <= graduation_date) &&
        (today > (graduation_date - 1.year))
    end

    def studying_not_final_year?
      # we are not in the final year if there is at least 1 year to go to graduation
      degree_in_progress? &&
        graduation_year.present? &&
        (today <= (graduation_date - 1.year))
    end

  private

    def reset_creation_channel_service_id?
      # for users with a degree in progress, we should re-set the creation_channel_service_id if the user is in the default TTA funnel and a valid creation_channel_service_id hasn't already be provided
      degree_in_progress? &&
        (creation_channel_source_id.present? || creation_channel_activity_id.present? || channel_id.nil?) &&
        (tta? || !creation_channel_service_id.in?(creation_channel_service_ids))
    end

    def channel_id
      other_step(:identity).channel_id
    end

    def creation_channel_source_id
      other_step(:identity).creation_channel_source_id
    end

    def creation_channel_activity_id
      other_step(:identity).creation_channel_activity_id
    end

    def creation_channel_service_ids
      @creation_channel_service_ids ||= GetIntoTeachingApiClient::PickListItemsApi.new.get_contact_creation_channel_services.map { |obj| obj.id.to_i }
    end

    def tta?
      other_step(:returning_teacher).tta?
    end

    def graduation_year_not_in_the_past
      if graduation_year.present? && graduation_year < Time.current.year
        errors.add(:graduation_year, "Your expected graduation year cannot be in the past")
      end
    end

    def graduation_year_not_too_far_in_the_future
      if graduation_year.present? && graduation_year >= Time.current.year + 10
        errors.add(:graduation_year, "Your expected graduation year cannot be more than 10 years from now")
      end
    end

    def today
      Time.zone.today
    end

    def graduation_date
      Date.new(graduation_year, GRADUATION_MONTH, GRADUATION_DAY)
    end
  end
end
