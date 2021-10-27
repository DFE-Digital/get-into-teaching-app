module MailingList
  module Steps
    class Age < ::Wizard::Step
      # multi parameter date fields aren't yet support by ActiveModel so we
      # need to include the support for them from ActiveRecord
      require "active_record/attribute_assignment"
      include ::ActiveRecord::AttributeAssignment

      MIN_AGE = 16.years.ago.to_date
      MAX_AGE = 70.years.ago.to_date
      DISPLAY_OPTIONS = {
        none: "none",
        date_of_birth: "date_of_birth",
        year_of_birth: "year_of_birth",
        age_range: "age_range",
      }.freeze

      attribute :age_display_option, :string
      attribute :year_of_birth, :integer
      attribute :date_of_birth, :date
      attribute :age_range, :string

      validates :age_display_option, inclusion: { in: DISPLAY_OPTIONS.values }
      validates :year_of_birth, format: { with: /\d{4}/ }, numericality: {
        greater_than_or_equal_to: ->(_) { MAX_AGE.year },
        less_than_or_equal_to: ->(_) { MIN_AGE.year },
      }, allow_blank: true
      validates :year_of_birth, presence: true, if: :display_year_of_birth?
      validates :age_range, inclusion: { in: ->(age) { age.class.age_ranges } }, allow_blank: true
      validates :age_range, presence: true, if: :display_age_range?
      validates :date_of_birth, timeliness: {
        on_or_before: MIN_AGE,
        on_or_after: MAX_AGE,
      }, allow_blank: true
      validates :date_of_birth, presence: true, if: :display_date_of_birth?

      before_validation :date_of_birth, :add_invalid_error

      class << self
        def age_ranges
          [
            "16-17",
            "18-24",
            "25-29",
            "30-39",
            "40-49",
            "50+",
          ]
        end
      end

      # Rescue argument error thrown by
      # validates_timeliness/extensions/multiparameter_handler.rb
      # when the user enters a DOB like `-1, -1, -2`.
      # Date of birth will be unset and a custom error message added later.
      def date_of_birth=(value)
        @date_of_birth_invalid = false
        super
      rescue ArgumentError
        @date_of_birth_invalid = true
        nil
      end

      def skipped?
        age_display_option == DISPLAY_OPTIONS[:none] || !Rails.application.config.x.mailing_list_age_step
      end

      def export
        {}
      end

      def display_date_of_birth?
        age_display_option == DISPLAY_OPTIONS[:date_of_birth]
      end

      def display_year_of_birth?
        age_display_option == DISPLAY_OPTIONS[:year_of_birth]
      end

      def display_age_range?
        age_display_option == DISPLAY_OPTIONS[:age_range]
      end

    private

      def add_invalid_error
        errors.add(:date_of_birth, :invalid) if @date_of_birth_invalid
      end
    end
  end
end
