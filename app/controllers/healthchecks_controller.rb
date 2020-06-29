class HealthchecksController < ApplicationController
  def show
    @healthcheck = Healthcheck.new
    render json: @healthcheck
  end
end
