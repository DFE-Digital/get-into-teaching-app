require_relative "./user"

class BasicAuth
  class << self
    def authenticate(username, password)
      return false unless [username, password].all?(&:present?)

      user = credentials.find { |c| c[:username] == username && c[:password] == password }
      User.new(user[:username], user[:role]) if user.present?
    end

    def credentials
      @@credentials ||= http_auth.split(",").map do |credential|
        username, password, role = credential.split("|")
        { username: username, password: password, role: role }.with_indifferent_access
      end
    end

    def http_auth
      Rails.application.config.x.http_auth || ""
    end

    def env_requires_auth?
      basic_auth = Rails.application.config.x.basic_auth

      return false if basic_auth.blank?

      ActiveModel::Type::Boolean.new.cast(basic_auth)
    end
  end
end
