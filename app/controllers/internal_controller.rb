class InternalController < ApplicationController
  helper_method :publisher?, :username
  before_action :authorize_user

private

  def authorize_user
    render_forbidden unless publisher? || author?
  end

  def publisher?
    session[:user].role == "publisher"
  end

  def author?
    session[:user].role == "author"
  end

  def username
    session[:user].username
  end

  def authenticate?
    true
  end
end
