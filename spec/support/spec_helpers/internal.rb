module SpecHelpers
  module Internal
    def generate_auth_headers(login_type)
      if login_type == :publisher
        username = ENV["PUBLISHER_USERNAME"]
        password = ENV["PUBLISHER_PASSWORD"]
      elsif login_type == :author
        username = ENV["AUTHOR_USERNAME"]
        password = ENV["AUTHOR_PASSWORD"]
      elsif login_type == :bad_credentials
        username = "wrong"
        password = "wrong"
      end

      { "HTTP_AUTHORIZATION" =>
          ActionController::HttpAuthentication::Basic.encode_credentials(
            username,
            password,
          ) }
    end
  end
end
