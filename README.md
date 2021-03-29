#  DFE-Digital Get Into Teaching website

## Prerequisites

- Ruby 2.7.2
- NodeJS 12.15.x
- Yarn 1.12.x

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
7. install ruby 2.7.2
Run `rvm install ruby 2.7.2`
8. switch your system to use ruby 2.7.2`
Run `rvm use 2.7.2`
9. install yarn
Run `brew install yarn`
10. install the bundler gem
Run `gem install bundler:2.1.4`

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

[Prettier](https://prettier.io/) is used for code formatting.
To enforce stylistic rules with Prettier (note: this overwrites the file), run:

```js
yarn prettier --write <path to your file>
```

[ESLint](https://eslint.org/) is used for static analysis of JavaScript code quality. It is configured to ignore stylistic rules that conflict with Prettier, and uses the [JavaScript Standard style](https://standardjs.com/).

To check a file:

```js
yarn eslint <path to your file>
```

### CSS

[StyleLint](https://stylelint.io/) is used for CSS linting, it uses the [GDS Stylelint Config](https://github.com/alphagov/stylelint-config-gds).

To lint the `./app/webpacker/styles` directory:

```js
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



