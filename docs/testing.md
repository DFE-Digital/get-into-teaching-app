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
