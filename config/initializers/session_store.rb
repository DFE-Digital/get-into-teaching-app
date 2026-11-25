# Sessions live in Solid Cache (primary database) under their own namespace.
# Solid Cache only deletes rows by max_age/max_size (see config/cache.yml).
session_cache =
  if Rails.env.test?
    # Solid Cache runs background threads that use the shared, transaction-locked
    # test DB connection, causing flaky "message type 0x.. arrived from server
    # while idle" errors. An in-memory store keeps Ruby types like the real one.
    ActiveSupport::Cache::MemoryStore.new(expires_in: 1.day)
  else
    ActiveSupport::Cache.lookup_store(
      :solid_cache_store,
      namespace: "GIT-SESSION",
      expires_in: 1.day,
    )
  end

Rails.application.config.session_store :cache_store,
                                       key: "_dfe_session",
                                       same_site: :lax,
                                       secure: Rails.env.production?,
                                       cache: session_cache,
                                       expire_after: 1.day
