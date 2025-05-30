class ChatsController < ApplicationController
  def show
    expires_in 1.minute, public: true
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
    use_secure_headers_override(:chat)
    window_envs
    render layout: "chat"
  end

  def show_json
    use_secure_headers_override(:api)
    render json: Chat.new
  end

  def authenticate?
    false
  end

  def window_envs
    @window_envs ||= {
      CHAT_ENVIRONMENT: ENV["CHAT_ENVIRONMENT"] || "etc",
      TENANT_TARGET: ENV["CHAT_TENANT_TARGET"],
      CHANNEL_ID_TARGET: ENV["CHAT_CHANNEL_ID_TARGET"],
    }
  end
end
