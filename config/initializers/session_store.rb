if Rails.env.development? || Rails.env.test?
  Rails.application.config.session_store :cookie_store,
                                         key: "_dfe_session",
                                         same_site: :lax,
                                         secure: false
else
  Rails.application.config.session_store :stored_session_store,
                                         key: "_dfe_session",
                                         same_site: :lax,
                                         secure: true

  Rails.application.config.after_initialize do
    StoredSession.config.session_max_created_age = 1.day
    StoredSession.config.session_max_updated_age = 1.day
  end
end
