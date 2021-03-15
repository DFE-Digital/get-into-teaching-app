class EligibilityCheckerController < ApplicationController
  class Eligibility
    include ActiveModel::Model

    attr_accessor :gcse_english, :gcse_maths, :gcse_science, :degree

    def any_checked?
      [gcse_english, gcse_maths, gcse_science, degree].any?
    end

    def all_checked?
      [gcse_english, gcse_maths, gcse_science, degree].all?
    end

    def gcses_but_no_degree?
      [gcse_english, gcse_maths].all? && !degree
    end

    def no_science?
      [gcse_english, gcse_maths, degree].all? && !gcse_science
    end

    def no_english_or_maths?
      any_checked? && (!gcse_english || !gcse_maths)
    end
  end

  def show
    @eligibility = Eligibility.new(**eligibility_params)
  end

private

  def eligibility_params
    params.permit(:gcse_english, :gcse_maths, :gcse_science, :degree)
      .to_hash
      .transform_values do |v|
        ActiveModel::Type::Boolean.new.cast(v)
      end
  end
end
