module GraduationYearMethods
  GRADUATION_MONTH = 8
  GRADUATION_DAY = 31

  def today
    Time.zone.today
  end

  def current_year
    Time.current.year
  end

  def graduation_year?
    graduation_year.present?
  end

  def graduation_date
    Date.new(graduation_year, GRADUATION_MONTH, GRADUATION_DAY) if graduation_year?
  end

  def graduating_first_year?
    # we are in the first year if there are more than than 2 years to go to graduation
    (today <= (graduation_date - 2.years)) if graduation_year?
  end

  def graduating_final_year?
    # we are in the final year if there is less than 1 year to go to graduation
    ((today + 1.year) > graduation_date) if graduation_year?
  end

  def graduating_not_final_year?
    # we are not in the final year if there is at least 1 year to go to graduation
    ((today + 1.year) <= graduation_date) if graduation_year?
  end

  def validate_graduation_year_in_the_past
    if graduation_year? && graduation_year < current_year
      errors.add(:graduation_year, "Your expected graduation year cannot be in the past")
    end
  end

  def validate_graduation_year_too_far_in_the_future
    if graduation_year? && graduation_year >= current_year + 10
      errors.add(:graduation_year, "Your expected graduation year cannot be more than 10 years from now")
    end
  end
end
