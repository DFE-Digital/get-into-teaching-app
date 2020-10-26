class ApplicationController < ActionController::Base
  include UtmCodes

  rescue_from ActionController::RoutingError, with: :render_not_found

  before_action :http_basic_authenticate
  before_action :record_utm_codes

  def raise_not_found
    raise ActionController::RoutingError, "Not Found"
  end

private

  def render_not_found
    render template: "errors/not_found", status: :not_found
  end

  def http_basic_authenticate
    return true if ENV["HTTPAUTH_USERNAME"].blank?

    authenticate_or_request_with_http_basic do |name, password|
      name == ENV["HTTPAUTH_USERNAME"].to_s &&
        password == ENV["HTTPAUTH_PASSWORD"].to_s
    end
  end
end
