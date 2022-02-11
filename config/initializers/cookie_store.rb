if Rails.env.development? || Rails.env.test?
  Rails.application.config.session_store :cookie_store,
                                         key: "_dfe_session",
                                         same_site: :lax,
                                         secure: false
else
  Rails.application.config.session_store :redis_session_store, {
    key: "_dfe_session",
    same_site: :lax,
    secure: true,
    redis: {
      expire_after: 1.day,
      ttl: 1.day,
      key_prefix: "get-into-teaching-app:session:",
      url: ENV["REDIS_URL"],
    },
  }
end
