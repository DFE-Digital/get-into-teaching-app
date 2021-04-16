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
    authenticate_or_request_with_http_basic do |username, password|
      return false if username.blank? || password.blank?

      if username == publisher[:username] && password == publisher[:password]
        set_account_role(:publisher)
      elsif username == author[:username] && password == author[:password]
        set_account_role(:author)
      end

      session[:role].present?
    end
  end

  def publisher
    {
      username: Rails.application.config.x.publisher_username,
      password: Rails.application.config.x.publisher_password,
    }
  end

  def author
    {
      username: Rails.application.config.x.author_username,
      password: Rails.application.config.x.author_password,
    }
  end
end
