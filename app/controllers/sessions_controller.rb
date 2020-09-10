class SessionsController < ApplicationController
  def crsf_token
    render json: { token: form_authenticity_token }
  end
end
