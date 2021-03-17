class ApplicationController < ActionController::Base
  include UtmCodes

  rescue_from ActionController::RoutingError, with: :render_not_found
  rescue_from GetIntoTeachingApiClient::ApiError, with: :handle_api_error
  rescue_from Pages::Page::PageNotFoundError, with: :render_not_found

  before_action :http_basic_authenticate
  before_action :set_api_client_request_id
  before_action :record_utm_codes
  before_action :add_home_breadcrumb

  def raise_not_found
    raise ActionController::RoutingError, "Not Found"
  end

private

  def set_api_client_request_id
    # The request_id is passed to the ApiClient via Thread.current
    # so we don't have to set it explicitly on every usage.
    GetIntoTeachingApiClient::Current.request_id = request.uuid
  end

  def add_home_breadcrumb
    return if request.path == root_path

    breadcrumb "home", :root_path
  end

  def handle_api_error(error)
    render_too_many_requests && return if error.code == 429
    render_not_found && return if error.code == 404

    raise
  end

  def render_not_found
    render template: "errors/not_found", layout: "application", status: :not_found, formats: %i[html]
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
