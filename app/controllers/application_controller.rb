class ApplicationController < ActionController::Base
  include UtmCodes

  rescue_from ActionController::RoutingError, with: :render_not_found
  rescue_from GetIntoTeachingApiClient::ApiError, with: :handle_api_error

  before_action :http_basic_authenticate
  before_action :record_utm_codes

  def raise_not_found
    raise ActionController::RoutingError, "Not Found"
  end

private

  def handle_api_error(error)
    render_too_many_requests && return if error.code == 429
    render_not_found && return if error.code == 404

    raise
  end

  def render_not_found
    render template: "errors/not_found", layout: "application", status: :not_found
  end

  def render_too_many_requests
    render template: "errors/too_many_requests", layout: "application", status: :too_many_requests
  end

  def http_basic_authenticate
    return true if ENV["HTTPAUTH_USERNAME"].blank?

    authenticate_or_request_with_http_basic do |name, password|
      name == ENV["HTTPAUTH_USERNAME"].to_s &&
        password == ENV["HTTPAUTH_PASSWORD"].to_s
    end
  end
end
