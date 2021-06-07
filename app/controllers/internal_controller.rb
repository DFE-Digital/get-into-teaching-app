class InternalController < ApplicationController
  before_action :authenticate
  helper_method :publisher?

private

  def publisher?
    session[:role] == :publisher
  end

  def set_account_role(role_type)
    session[:role] = role_type
  end

  def authenticate?
    true
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
