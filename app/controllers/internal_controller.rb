class InternalController < ApplicationController
  before_action :set_current_user, :authorize_user

private

  def set_current_user
    @user = current_user
  end

  def authorize_user
    render_forbidden unless @user.publisher? || @user.author?
  end

  def current_user
    session[:user]
  end

  def authenticate?
    true
  end
end
