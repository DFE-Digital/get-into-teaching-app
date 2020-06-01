#  DFE-Digital Get into Teaching website

## Prerequisites

- Ruby 2.6.6
- NodeJS 12.15.x
- Yarn 1.12.x

## Setting up the app in development

1. Run `bundle install` to install the gem dependencies
2. Run `yarn` to install node dependencies
4. Run `bundle exec rails server` to launch the app on http://localhost:3000
5. Run `./bin/webpack-dev-server` in a separate shell for faster compilation of assets

## Whats included in this website

- Rails 6.0 with Webpacker
- RSpec
- Dotenv (managing environment variables)
- Dockerbuild file
- GitHub Actions based CI

## Content for this website

The static content for this website is held in a separate [Content repository](https://github.com/DFE-Digital/get-into-teaching-content)

When the application in this repository is deployed, it builds a Docker Image,
then triggers a build of the Content Repo which builds its own Docker Image 
layered on top of this one.

## Running specs, linter(without auto correct) and annotate models and serializers
```
bundle exec rake
```

## Running specs
```
bundle exec rspec
```

## Linting

It's best to lint just your app directories and not those belonging to the framework, e.g.

```bash
bundle exec rubocop app config db lib spec Gemfile --format clang -a

or

bundle exec scss-lint app/webpacker/styles
```

You can automatically run the Ruby linter on commit for any changed files with 
the following pre-commit hook `.git/hooks/pre-commit`.

```bash
#!/bin/sh
if [ "x$SKIPLINT" == "x" ]; then
    exec bundle exec rubocop $(git diff --cached --name-only --diff-filter=ACM | egrep '\.rb|\.feature|\.rake' | grep -v 'db/schema.rb') Gemfile
fi
```

## Configuration

### Environments

The application has 2 extra Rails environments, in addition to the default 3.

1. `development` - used for local development
2. `test` - used for running the test suites in an isolated manner
3. `production` - the 'live' production copy of the application
4. `rolling` - 'production-like' - continuously delivered, reflects current master
5. `preprod` - 'production-like' - stage before release to final production

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

### Variables

`HTTPAUTH_USERNAME` and `HTTPAUTH_PASSWORD` - setting both enables site wide 
password protection



