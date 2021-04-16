module SpecHelpers
  module Internal
    def generate_auth_headers(login_type)
      allow(Rails.application.config.x).to receive(:publisher_username) { "publisher" }
      allow(Rails.application.config.x).to receive(:publisher_password) { "password" }
      allow(Rails.application.config.x).to receive(:author_username) { "author" }
      allow(Rails.application.config.x).to receive(:author_password) { "password" }

      if login_type == :publisher
        username = "publisher"
      elsif login_type == :author
        username = "author"
      elsif login_type == :bad_credentials
        username = "wrong"
      end

      { "HTTP_AUTHORIZATION" =>
          ActionController::HttpAuthentication::Basic.encode_credentials(
            username,
            "password",
          ) }
    end
  end
end
