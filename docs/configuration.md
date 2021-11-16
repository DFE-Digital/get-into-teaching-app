## Configuration

### Environments

The application has 2 extra Rails environments, in addition to the default 3.

1. `development` - used for local development
2. `test` - used for running the test suites in an isolated manner
3. `production` - the 'live' production copy of the application
4. `rolling` - 'production-like' - continuously delivered, reflects current master
5. `preprod` - 'production-like' - stage before release to final production
6. `pagespeed` - 'production-like' - pipes page speed metrics to Prometheus on boot

**NOTE:** It is **important** if checking for the production environment to also
check for other 'production-like' environments unless you really intend to only
check for production, ie.

```ruby
if Rails.env.rolling? || Rails.env.preprod? || Rails
```

### Public Configuration

First its worth mentioning that all config from `production.rb` is inherited by
both `rolling.rb` and `preprod.rb` so separate configuration may not be required

Publicly visible Environment Variables can be added to the relevant `.env`
files for each environment

1. `/.env.production`
2. `/.env.rolling`
3. `/.env.preprod`

### Private Configuration - ie secrets

These can be recorded in the relevant environments encrypted credentials file

```bash
bundle exec rails credentials:edit --environment <environment-name>
```

You will either need to have `RAILS_MASTER_KEY` set within your environment or
have have the appropriate `/config/credentials/<env-name>.key` file with the
environments master key in.

### HTTP Basic authentication

The app uses HTTP Basic authentication for two purposes:
- To restrict access (site-wide) to any of the production-like environments (except production itself). 
- To restrict access to the `/internal/` path, which is not intended for public use. Access is granted to users with either a `publisher` or `author` role (see `./lib/user.rb`). The `publisher` user type has elevated permissions.

Users are stored as comma separated list in the following format:

```yaml
username|password|role,username2|password2|role2
```

If a user does not require a role (site-wide authentication), the role credential can be omitted:

```yaml
username|password
```
