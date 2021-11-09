#  DFE-Digital Get Into Teaching website

## Prerequisites

- Ruby 2.7.4
- NodeJS 12.22.x
- Yarn 1.22.x

## Status

[![View performance data on Skylight](https://badges.skylight.io/status/cCXe4O12iXtO.svg?token=dmQT0j0nuvDKRWL0RSr5ZMr-ARd25yfRzTePxnMsLYU)](https://www.skylight.io/app/applications/cCXe4O12iXtO)
[![View traffic data on Skylight](https://badges.skylight.io/rpm/cCXe4O12iXtO.svg?token=dmQT0j0nuvDKRWL0RSr5ZMr-ARd25yfRzTePxnMsLYU)](https://www.skylight.io/app/applications/cCXe4O12iXtO)
[![View typical response times on Skylight](https://badges.skylight.io/typical/cCXe4O12iXtO.svg?token=dmQT0j0nuvDKRWL0RSr5ZMr-ARd25yfRzTePxnMsLYU)](https://www.skylight.io/app/applications/cCXe4O12iXtO)
[![View problem response times on Skylight](https://badges.skylight.io/problem/cCXe4O12iXtO.svg?token=dmQT0j0nuvDKRWL0RSr5ZMr-ARd25yfRzTePxnMsLYU)](https://www.skylight.io/app/applications/cCXe4O12iXtO)

## Mac Setup (as of Catalina 11-07-20)

1. install homebrew, this will ask to install the xcode command line tools if you dont have it already
Run `/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"`
2. install gpg2
Run `brew install gpg2`
3. import the RVM keys *do not use these keys* get them from the official website (https://rvm.io/rvm/security) as they change often
Run `gpg --keyserver hkp://pool.sks-keyservers.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB`
4. trust the first key
Run `echo 409B6B1796C275462A1703113804BB82D39DC0E3:6: | gpg2 --import-ownertrust # mpapis@gmail.com`
5. install rvm
Run `\curl -sSL https://get.rvm.io | bash -s stable`
6. enable rvm (replace <your-user-name>)
Run `source /Users/<your-user-name>/.rvm/scripts/rvm`
7. install ruby 2.7.4
Run `rvm install ruby 2.7.4`
8. switch your system to use ruby 2.7.4`
Run `rvm use 2.7.4`
9. install yarn
Run `brew install yarn`
10. install the bundler gem
Run `gem install bundler:2.2.8`

## Setting up the app in development

1. Run `bundle install` to install the gem dependencies
2. Run `yarn` to install node dependencies
4. Run `bundle exec rails server` to launch the app on http://localhost:3000
5. Run `./bin/webpack-dev-server` in a separate shell for faster compilation of assets

## Copy the content your local machine.
Content for this website is stored in a seperate repo and is added in by the CI/CD pipeline.
You will need to do this manually to have the content available on your local development environment.

1. Clone the following repo: https://github.com/DFE-Digital/get-into-teaching-content
2. Copy the `content` folder from this repo and merge it into `app/views/content`

Alternatively, create a [symlink](https://en.wikipedia.org/wiki/Symbolic_link)
from `apps/views/content` to the location of your content directory by changing
to your `app/views` directory and running `ln -s content
/the/path/to/your/content/directory`.

## Whats included in this website

- Rails 6.1 with Webpacker
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

**Dependencies:** The Chrome and chromedriver need to be installed for the feature tests.
Alternatively, install the chromium and chromium-chromedriver for smaller footprint.

To run the Ruby specs

```
bundle exec rspec
```

To run the Javascript specs

```
bundle exec yarn spec
```

## Linting

It's best to lint just your app directories and not those belonging to the framework, e.g.

```bash
bundle exec rubocop app config db lib spec Gemfile --format clang -a
```

You can automatically run the Ruby linter on commit for any changed files with
the following pre-commit hook `.git/hooks/pre-commit`.

```bash
#!/bin/sh
if [ "x$SKIPLINT" == "x" ]; then
    exec bundle exec rubocop $(git diff --cached --name-only --diff-filter=ACM | egrep '\.rb|\.feature|\.rake' | grep -v 'db/schema.rb') Gemfile
fi
```

### JavaScript

[Prettier](https://prettier.io/) is used for code formatting. [ESLint](https://eslint.org/) is used for static analysis of JavaScript code quality. It is configured to ignore stylistic rules that conflict with Prettier, and uses the [JavaScript Standard style](https://standardjs.com/).

To list any violations in the project's JavaScript:

```bash
yarn js-lint
```

To automatically fix any violations. Any violations that cannot be automatically fixed will be listed in the output (note: this will overwrite any file that needs formatting):

```bash
yarn js-lint-fix
```

### CSS

[StyleLint](https://stylelint.io/) is used for CSS linting, it uses the [GDS Stylelint Config](https://github.com/alphagov/stylelint-config-gds).

To lint the `./app/webpacker/styles` directory:

```bash
# Run StyleLint
yarn scss-lint

# Automatically fix, where possible, violations reported by rules
yarn scss-lint --fix
```

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
