class HealthchecksController < ApplicationController
  skip_before_action :http_basic_authenticate

  def show
    @healthcheck = Healthcheck.new
    Rails.logger.info("HealthCheck: #{@healthcheck.to_h}")
    render json: @healthcheck
  end
end
