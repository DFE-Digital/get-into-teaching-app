class ChatsController < ApplicationController
  def show
    respond_to do |format|
      format.html do
        show_html
      end

      format.json do
        show_json
      end

      format.all do
        render status: :not_found, body: nil
      end
    end
  end

private

  def show_html
    render layout: "chat"
  end

  def show_json
    # De-activate the CSP header on the chats page
    SecureHeaders.opt_out_of_header(request, "csp")
    render json: Chat.new
  end

  def authenticate?
    false
  end
end
