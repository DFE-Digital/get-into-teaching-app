class HealthchecksController < ApplicationController
  skip_before_action :site_wide_authentication

  def show
    @healthcheck = Healthcheck.new
    Rails.logger.info("HealthCheck: #{@healthcheck.to_h}")
    render json: @healthcheck
  end
end
