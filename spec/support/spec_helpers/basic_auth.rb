module SpecHelpers
  module BasicAuth
    def allow_basic_auth_users(credentials = [])
      allow(::BasicAuth).to receive(:authenticate).and_return(false)

      credentials.each do |c|
        allow(::BasicAuth).to receive(:authenticate).with(c[:username], c[:password]).and_return(true)
      end
    end

    def basic_auth_headers(username, password)
      value = ActionController::HttpAuthentication::Basic.encode_credentials(username, password)
      { "HTTP_AUTHORIZATION" => value }
    end

    def generate_auth_headers(login_type)
      case login_type
      when :publisher
        username = publisher_username
        password = publisher_password
      when :author
        username = author_username
        password = author_password
      else
        username = "bad_username"
        password = "bad_password"
      end

      basic_auth_headers(username, password)
    end
  end
end
