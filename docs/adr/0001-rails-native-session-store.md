# ADR 0001: Move session management from Redis to a Rails-native session store

- **Status:** Proposed (documentation only; no runtime change is made by this ADR)
- **Scope:** Rails session storage (`_dfe_session`). Other Redis use (Sidekiq, the Rails cache) is out of scope.

## Context

In production, sessions are stored in Redis using the `redis-session-store` gem (`config/initializers/cookie_store.rb`):

- cookie key `_dfe_session`, `same_site: :lax`, `secure: true`
- Redis key prefix `get-into-teaching-app:session:`, expiry 1 day
- Development and test use Rails' built-in `:cookie_store`.

Sessions hold more than a login. The app keeps multi-step form answers and CRM-derived data in the session, for example `session[:sign_up]`, `session[:callbacks]`, `session[:events][event_id]`, `session[:mailinglist]`, `session[:feedback]`, `session[:routes_into_teaching]` and their `*_crm` counterparts. It also keeps `session[:user]` (internal users) and `session[:privacy_policy_id]`. These can contain personal data (names, email addresses, phone numbers).

**Sessions can exceed 4 KB**, so the cookie store (which holds the whole session in the browser cookie) cannot be used in production. A server-side store is required.

Redis is a separate service to run, patch and monitor. `config/initializers/02_redis.rb` raises at boot if Redis is unreachable, and `Healthcheck` reports Redis status. `redis-session-store` is a third-party gem that must stay compatible with Rails (currently 8.1).

## Decision

Replace Redis-backed sessions with Rails' built-in **`:cache_store` session store**, with `Rails.cache` backed by **Solid Cache on the primary database**. Stop using `redis-session-store`.

1. Configure `config.session_store :cache_store` in production, keeping the cookie name `_dfe_session`, `same_site: :lax` and `secure: true`, with `expire_after: 1.day` (matching today's expiry). The cookie holds only a session ID; the data stays on the server.
2. Use a **separate Solid Cache store instance with its own namespace** for sessions, so session keys are distinct from the general application cache. All stores share one `solid_cache_entries` table, so eviction is shared: size and age limits apply across namespaces, and a cache clear would also remove sessions unless it is namespace-scoped. Sessions must be excluded from any cache-clearing procedure.
3. Solid Cache removes rows only by `max_age` and `max_size`, not by `expires_in` (expired entries are just not returned). Set `max_age` (`config/cache.yml`, currently 2 days) longer than the longest TTL stored, and size `max_size` so live sessions are not evicted early.
4. Development and test keep their current cookie/null/memory configuration. Production behaviour is covered by a test that uses a session larger than 4 KB.
5. Remove the `redis-session-store` gem and the session configuration once the switch is complete. The `redis` gem and the `REDIS` pool are only removed when nothing else uses them.

## Rationale and consequences

- **Rails-native:** the store, the cache backend and the cleanup are all supported Rails components, with no third-party session gem.
- **Fewer moving parts:** sessions no longer depend on Redis; the primary database is already operated and backed up.
- **No 4 KB limit:** session size is bounded only by the cache entry limits (`max_entry_size`), which must be checked against the largest journey.
- **Database load grows:** every request that touches the session reads, and often writes, a database row. Check capacity and the connection pool per process with Technical Infrastructure before switching. A capacity problem is escalated, not fixed by assuming a scale-up.
- **Sessions in backups and exports:** session data contains personal data and now goes into database backups. Apply the same retention and access rules, and keep sessions out of logs and exports.
- **Session loss on eviction:** a cache-backed session can disappear before its expiry if the store is under size pressure; the user then restarts their form. This is a deliberate trade-off against building a bespoke session table.
- **Expiry handling:** Solid Cache trims rows in the background after writes (it runs its expiry on write via the Active Job queue, currently Sidekiq). Confirm this runs in production.
- **Revocation:** deleting a session entry logs a user out, which is possible for individual sessions if needed.
- **In-flight sessions are lost at cutover:** existing Redis sessions are not read by the new store, so users mid-journey restart their form. This is acceptable given the 1 day lifetime; switch outside peak times.
- **Serialisation:** the cache serialises session values with Marshal by default. Confirm that `session[:user]` and other values behave as they do today.

## Alternatives rejected

- **Cookie store:** sessions can exceed 4 KB, so it would raise `CookieOverflow`.
- **Keep Redis sessions:** keeps the extra service, the third-party gem and the outage coupling.
- **ActiveRecord session store:** not part of Rails (separate `activerecord-session_store` gem); needs its own table and cleanup.
- **Custom server-side session table:** more code to build and secure than the problem justifies.
- **`:cache_store` on Redis:** Rails-native, but still depends on Redis.
- **Shrinking the session so the cookie store fits:** fragile; any new journey could break it again.

## Rollout

Each step is a separate change.

1. **Prechecks** (see below).
2. **Add Solid Cache** on the primary database, with a dedicated session store or namespace. Verify expiry and eviction settings.
3. **Switch production sessions** to `:cache_store`. Monitor database load, error rates and session-related errors in Sentry for the first days.
4. **Remove** `redis-session-store` and the Redis session configuration; Redis session keys expire on their own after 1 day.

Rollback: reverting the code restores Redis sessions, but sessions created in the database in the meantime are not migrated, so users restart their form. Keep the Redis service until step 4 is complete.

## Open checks (not yet performed)

- Largest realistic session size per journey, against Solid Cache entry limits.
- Database capacity and per-process connection pool, with Technical Infrastructure.
- Solid Cache `max_age` and `max_size` values (currently 2 days and 256 MB placeholders) against real session volume.
- Whether `session[:user]` and other values serialise correctly with the cache store.
- Other code or tooling that depends on Redis session keys.
- Whether anything else still needs Redis, which decides when the service and the `Healthcheck` Redis check can be removed.
