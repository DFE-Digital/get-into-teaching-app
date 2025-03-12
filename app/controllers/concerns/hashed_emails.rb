module HashedEmails
  GIT_COOKIE_PREFERENCES = "git-cookie-preferences-v1".freeze

  def hash_email_address?
    return unless cookies[GIT_COOKIE_PREFERENCES]

    JSON.parse(cookies[GIT_COOKIE_PREFERENCES]).then do |prefs|
      prefs["functional"] && prefs["marketing"]
    end
  rescue JSON::ParserError
    false
  end
end
