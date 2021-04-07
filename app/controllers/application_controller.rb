require "next_gen_images"

class ApplicationController < ActionController::Base
  include UtmCodes

  rescue_from ActionController::RoutingError, with: :render_not_found
  rescue_from GetIntoTeachingApiClient::ApiError, with: :handle_api_error
  rescue_from Pages::Page::PageNotFoundError, with: :render_not_found

  before_action :http_basic_authenticate
  before_action :set_api_client_request_id
  before_action :record_utm_codes
  before_action :add_home_breadcrumb

  after_action :insert_next_gen_images, if: -> { Rails.env.preprod? }

  def raise_not_found
    raise ActionController::RoutingError, "Not Found"
  end

private

  def insert_next_gen_images
    return unless response.headers["Content-Type"]&.include?("text/html")

    response.body = NextGenImages.new(response.body).html
  end

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
    render_error :not_found
  end

  def render_too_many_requests
    render_error :too_many_requests
  end

  def http_basic_authenticate
    return true if ENV["HTTPAUTH_USERNAME"].blank?

    authenticate_or_request_with_http_basic do |name, password|
      name == ENV["HTTPAUTH_USERNAME"].to_s &&
        password == ENV["HTTPAUTH_PASSWORD"].to_s
    end
  end

  def render_error(status_code_symbol)
    unless status_code_symbol.is_a?(Symbol) # Guard against incorrect usage
      return render status: :invalid_server_error, body: nil
    end

    respond_to do |format|
      format.html do
        render \
          template: "errors/#{status_code_symbol}",
          layout: "application",
          status: status_code_symbol
      end

      format.all do
        render status: status_code_symbol, body: nil
      end
    end
  end
end
