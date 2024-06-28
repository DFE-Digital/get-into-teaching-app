module TeacherTrainingAdviser::Steps
  class DateOfBirth < GITWizard::Step
    # multi parameter date fields aren't yet support by ActiveModel so we
    # need to include the support for them from ActiveRecord
    require "active_record/attribute_assignment"
    include ::ActiveRecord::AttributeAssignment

    MIN_AGE = 18
    MAX_AGE = 70

    attribute :date_of_birth, :date

    validates :date_of_birth, presence: true
    validates :date_of_birth, timeliness: {
      on_or_before: MIN_AGE.years.ago,
      on_or_after: MAX_AGE.years.ago,
    }
    before_validation :date_of_birth, :add_invalid_error

    # Rescue argument error thrown by
    # validates_timeliness/extensions/multiparameter_handler.rb
    # when the user enters a DOB like `-1, -1, -2`.
    # date of birth will be unset and a custom error message later added
    def date_of_birth=(value)
      @date_of_birth_invalid = false
      super
    rescue ArgumentError
      @date_of_birth_invalid = true
      nil
    end

    def self.contains_personal_details?
      true
    end

    def reviewable_answers
      {
        "date_of_birth" => date_of_birth,
      }
    end

  private

    def add_invalid_error
      errors.add(:date_of_birth, :invalid) if @date_of_birth_invalid
    end
  end
end
