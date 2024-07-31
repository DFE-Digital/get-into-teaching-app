class ChatsController < ApplicationController
  def show
    # De-activate the CSP header on the chats page
    SecureHeaders.opt_out_of_header(request, "csp")

    @chat ||= Chat.new
    render json: @chat
  end

  private

  def authenticate?
    false
  end
end
