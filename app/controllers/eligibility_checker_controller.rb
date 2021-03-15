class EligibilityCheckerController < ApplicationController
  class Eligibility
    include ActiveModel::Model

    attr_reader :gcse_english, :gcse_maths, :gcse_science, :degree
  end

  def show
    @eligibility = OpenStruct.new(**eligibility_params)

    Rails.logger.debug(@eligibility)
  end

private

  def eligibility_params
    params.permit(:gcse_english, :gcse_maths, :gcse_science, :degree).to_hash
  end
end
