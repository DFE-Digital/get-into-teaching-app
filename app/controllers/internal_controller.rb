class InternalController < ApplicationController
  before_action :authenticate
  helper_method :publisher?

protected

  def publisher?
    session[:role] == :publisher
  end

private

  def set_account_role(role_type)
    session[:role] = role_type
  end

  def authenticate
    authenticated = true
    authenticate_or_request_with_http_basic do |username, password|
      if username == ENV["PUBLISHER_USERNAME"] && password == ENV["PUBLISHER_PASSWORD"]
        set_account_role(:publisher)
      elsif username == ENV["AUTHOR_USERNAME"] && password == ENV["AUTHOR_PASSWORD"]
        set_account_role(:author)
      else
        authenticated = false
      end
      authenticated
    end
  end
end
