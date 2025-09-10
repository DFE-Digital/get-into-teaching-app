module TeacherTrainingAdviser::Steps
  class HaveADegree < GITWizard::Step
    attribute :degree_option, :string
    attribute :degree_type_id, :integer
    attribute :graduation_year, :integer

    DEGREE_OPTIONS = [DEGREE_OPTION_YES = "yes".freeze,
                      DEGREE_OPTION_STUDYING = "studying".freeze,
                      DEGREE_OPTION_NO = "no".freeze].freeze

    GRADUATION_MONTH = 8
    GRADUATION_DAY = 31

    validates :degree_option,
              presence: { message: "Choose a degree option from the list" },
              inclusion: { in: DEGREE_OPTIONS }

    validates :graduation_year,
              format: {
                with: /\A\d{4}\z/,
                message: "Enter your expected graduation year",
              },
              numericality: { only_integer: true },
              presence: { message: "Enter your expected graduation year" },
              if: :studying?

    validate :graduation_year_not_in_the_past, if: :studying?

    validate :graduation_year_not_too_far_in_the_future, if: :studying?

    include FunnelTitle

    def degree_option=(value)
      super
      self.degree_type_id = case value
                            when DEGREE_OPTION_YES
                              Crm::OptionSet::DEGREE_STATUSES["Graduate or postgraduate"]
                            when DEGREE_OPTION_NO
                              Crm::OptionSet::DEGREE_STATUSES["I don't have a degree and am not studying for one"]
                            when DEGREE_OPTION_STUDYING
                              Crm::OptionSet::DEGREE_STATUSES["Not yet, I'm studying for one"]
                            end
    end

    def reviewable_answers
      if degree_option == DEGREE_OPTION_STUDYING
        {
          "degree_options" => degree_option ? I18n.t("helpers.answer.teacher_training_adviser_steps.have_a_degree.degree_options.#{degree_option}", **Value.data) : nil,
          "graduation_year" => graduation_year,
        }
      else
        {
          "degree_options" => degree_option ? I18n.t("helpers.answer.teacher_training_adviser_steps.have_a_degree.degree_options.#{degree_option}", **Value.data) : nil,
        }
      end
    end

    def skipped?
      other_step(:returning_teacher).returning_to_teaching
    end

    def has_degree?
      degree_option == DEGREE_OPTION_YES
    end

    def studying?
      degree_option == DEGREE_OPTION_STUDYING
    end

    def no_degree?
      degree_option == DEGREE_OPTION_NO
    end

    def studying_first_year?
      # we are in the first year if there are more than than 2 years to go to graduation
      studying? &&
        graduation_year.present? &&
        (today <= (graduation_date - 2.years))
    end

    def studying_final_year?
      # we are in the final year if there is less than 1 year to go to graduation
      studying? &&
        graduation_year.present? &&
        (today <= graduation_date) &&
        (today > (graduation_date - 1.year))
    end

    def studying_not_final_year?
      # we are not in the final year if there is at least 1 year to go to graduation
      studying? &&
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
