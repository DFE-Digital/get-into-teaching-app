module SpecHelpers
  module BasicAuth
    def allow_basic_auth_users(credentials = [])
      allow(::BasicAuth).to receive(:authenticate) { false }

      credentials.each do |c|
        allow(::BasicAuth).to receive(:authenticate).with(c[:username], c[:password]) { true }
      end
    end

    def basic_auth_headers(username, password)
      value = ActionController::HttpAuthentication::Basic.encode_credentials(username, password)
      { "HTTP_AUTHORIZATION" => value }
    end
  end
end
