require "basic_auth"

class ApplicationController < ActionController::Base
  class ForbiddenError < StandardError; end

  include UtmCodes

  rescue_from ActionController::RoutingError, with: :render_not_found
  rescue_from GetIntoTeachingApiClient::ApiError, with: :handle_api_error
  rescue_from ::Pages::Page::PageNotFoundError, with: :render_not_found

  before_action :http_basic_authenticate, if: :authenticate?
  before_action :set_api_client_request_id
  before_action :record_utm_codes
  before_action :add_home_breadcrumb
  before_action :declare_frontmatter

  after_action :cache

protected

  def static_page_actions
    # Override to specify which actions are serving
    # static page content and can therefore be cached.
    []
  end

  def noindex
    @noindex = true
  end

  def add_content_error(error)
    @content_errors ||= []
    @content_errors << error
  end

private

  def declare_frontmatter
    # Not all pages have frontmatter, but ensuring it
    # is declared everywhere simplifies its use throughout.
    @front_matter ||= {}
  end

  def cache
    if perform_caching? && action_name.to_sym.in?(static_page_actions)
      cache_page(nil, nil, Zlib::BEST_COMPRESSION)
    end
  end

  def raise_not_found
    raise ActionController::RoutingError, "Not Found"
  end

  def authenticate?
    BasicAuth.env_requires_auth?
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

  def render_forbidden
    render_error :forbidden
  end

  def render_too_many_requests
    render_error :too_many_requests
  end

  def http_basic_authenticate
    authenticate_or_request_with_http_basic do |username, password|
      user = BasicAuth.authenticate(username, password)
      if user.present?
        session[:user] = user
      else
        false
      end
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
