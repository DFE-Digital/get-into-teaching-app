if Rails.env.test?
  # use cookie_store for tests
  Rails.application.config.session_store :cookie_store,
                                         key: "_dfe_session",
                                         same_site: :lax,
                                         secure: false
else
  # Sessions live in Solid Cache (primary database) under their own namespace.
  # Solid Cache only deletes rows by max_age/max_size (see config/cache.yml).
  session_cache = ActiveSupport::Cache.lookup_store(
    :solid_cache_store,
    namespace: "GIT-SESSION",
    expires_in: 1.day,
  )

  Rails.application.config.session_store :cache_store,
                                         key: "_dfe_session",
                                         same_site: :lax,
                                         secure: !Rails.env.development?,
                                         cache: session_cache,
                                         expire_after: 1.day
end
