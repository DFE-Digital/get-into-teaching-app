module SpecHelpers
  module BasicAuth
    def allow_basic_auth_users(credentials = [])
      allow(::BasicAuth).to receive(:authenticate).and_return(false)

      credentials.each do |c|
        user = User.new(c[:username], c[:role])
        allow(::BasicAuth).to receive(:authenticate).with(c[:username], c[:password]).and_return(user)
      end
    end

    def basic_auth_headers(username, password)
      value = ActionController::HttpAuthentication::Basic.encode_credentials(username, password)
      { "HTTP_AUTHORIZATION" => value }
    end
  end
end
