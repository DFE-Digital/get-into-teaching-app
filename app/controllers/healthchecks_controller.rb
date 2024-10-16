class HealthchecksController < ApplicationController
  def show
    # De-activate the CSP header on the healthcheck page, to allow the system
    # to be monitored without over-sized CSP headers
    use_secure_headers_override(:api)

    @healthcheck = Healthcheck.new
    Rails.logger.info("HealthCheck: #{@healthcheck.to_h}")
    render json: @healthcheck
  end

private

  def authenticate?
    false
  end
end
