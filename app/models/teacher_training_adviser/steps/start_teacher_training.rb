module TeacherTrainingAdviser::Steps
  class StartTeacherTraining < GITWizard::Step
    attribute :initial_teacher_training_year_id, :integer

    validates :initial_teacher_training_year_id, inclusion: { in: :year_ids }

    NOT_SURE_ID = 12_917

    def reviewable_answers
      super.tap do |answers|
        answers["initial_teacher_training_year_id"] = years.find { |y| y.id == initial_teacher_training_year_id }&.value
      end
    end

    def years
      filter_items(itt_years).map do |item|
        item.value = formatted_value(item)
        item
      end
    end

    def year_ids
      years.map(&:id)
    end

    def skipped?
      have_a_degree_step = other_step(:have_a_degree)
      have_a_degree_skipped = have_a_degree_step.skipped?
      studying_not_final_year = have_a_degree_step.studying? && !other_step(:stage_of_degree).final_year?

      have_a_degree_skipped || studying_not_final_year
    end

    def inferred_year_id
      degree_status = other_step(:stage_of_degree).degree_status_id

      return unless other_step(:have_a_degree).studying? && degree_status.in?(StageOfDegree::NOT_FINAL_YEAR.values)

      inferred_year = if degree_status == StageOfDegree::NOT_FINAL_YEAR[:first_year]
                        current_year + (before_current_year_threshold? ? 2 : 3)
                      else
                        current_year + (before_current_year_threshold? ? 1 : 2)
                      end

      itt_years.find { |item| item.value == inferred_year.to_s }&.id
    end

  private

    def itt_years
      @itt_years ||= GetIntoTeachingApiClient::PickListItemsApi.new.get_candidate_initial_teacher_training_years
    end

    def formatted_value(item)
      return item.value if item.id == NOT_SURE_ID

      year = item.value.to_i

      if [first_year, current_year + 1].all?(year)
        "#{year} - start your training next September"
      elsif year == first_year
        "#{year} - start your training this September"
      else
        year.to_s
      end
    end

    def filter_items(items)
      items.select do |item|
        item.id == NOT_SURE_ID ||
          item.value.to_i.between?(first_year, first_year + number_of_years)
      end
    end

    def first_year
      before_current_year_threshold? ? current_year : current_year + 1
    end

    def before_current_year_threshold?
      # After 6th September you can no longer start teacher training for that year.
      Time.zone.today < date_to_drop_current_year
    end

    def number_of_years
      Time.zone.today.between?(date_to_add_additional_year, date_to_drop_current_year - 1.day) ? 3 : 2
    end

    def date_to_add_additional_year
      Date.new(current_year, 6, 24)
    end

    def date_to_drop_current_year
      Date.new(current_year, 9, 17)
    end

    def current_year
      current_date.year
    end

    def current_date
      Time.zone.today
    end
  end
end
