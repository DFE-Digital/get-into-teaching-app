class ApplicationController < ActionController::Base
  include UtmCodes

  before_action :http_basic_authenticate
  before_action :record_utm_codes

private

  def http_basic_authenticate
    return true if ENV["HTTPAUTH_USERNAME"].blank?

    authenticate_or_request_with_http_basic do |name, password|
      name == ENV["HTTPAUTH_USERNAME"].to_s &&
        password == ENV["HTTPAUTH_PASSWORD"].to_s
    end
  end
end
