class HealthchecksController < ApplicationController
  skip_before_action :http_basic_authenticate

  def show
    @healthcheck = Healthcheck.new
    render json: @healthcheck
  end
end
