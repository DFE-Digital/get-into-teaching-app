module TeacherTrainingAdviser::Steps
  class DegreeStatus < GITWizard::Step
    HAS_DEGREE = 222_750_000
    DEGREE_IN_PROGRESS = 222_750_006
    NO_DEGREE = 222_750_004

    GRADUATION_MONTH = 8
    GRADUATION_DAY = 31

    attribute :degree_status_id, :integer
    attribute :graduation_year, :integer

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

# attribute :degree_type_id, :integer
# QUALIFICATION_TYPE_HAS_DEGREE = 222_750_000
# QUALIFICATION_TYPE_HAS_DEGREE_EQUIVALENT = 222_750_005

# def degree_status_id=(value)
#   super
  # NB the old code to set degree_type_id was:
  # * if the user chose "I am not a UK citizen and have, or am studying for, an equivalent qualification", we
  #   would set degree_type_id to be HAS_DEGREE_EQUIVALENT=222_750_005
  # * otherwise, we would set degree_type_id to be HAS_DEGREE=222_750_000
  # this does not seem to be correct!
#
#   self.degree_type_id = case value
#                         when DEGREE_STATUS_HAS_DEGREE
#                           QUALIFICATION_TYPE_HAS_DEGREE
#
#                         when DEGREE_STATUS_IN_PROGRESS
#
#
#                         when DEGREE_STATUS_NO_DEGREE
#
#                         end
# end
