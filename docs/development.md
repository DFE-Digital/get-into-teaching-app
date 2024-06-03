# Development

## Setting up the app in development

* Run `bundle install` to install the gem dependencies
* Run `yarn` to install node dependencies
* Run `rails db:prepare` to setup the database
* Run `az login` and then `make local setup-local-env` to populate development secrets
* Run `bundle exec rails server` to launch the app on http://localhost:3000
* Run `./bin/shakapacker-dev-server` in a separate shell for faster compilation of assets

### Running the app with a local api

* Build the [get-into-teaching-api](https://github.com/DFE-Digital/get-into-teaching-api) following the documentation in that project. Configure it use a dev CRM instance and docker-based Redis and Postgresql database
* Run the API on https://localhost:5001/api
* Run the app using env vars to point to the local API:
```bash
GIT_API_ENDPOINT=https://localhost:5001/api  \
 GIT_API_TOKEN=secret-git  \
 bundle exec rails server
```

## Running the test suites

You need to have the correct version of `chromedriver` installed for the version of Chrome you are running.

* To run the Ruby tests: `rspec`
* To run the Javascript tests `yarn spec`

### Integration tests

We have a number of integration tests that will run on a deployment to production; these are exectured on our hosted test environment and perform end-to-end tests of the mailing list, event and adviser sign up journeys.

As we test the TOTP authentication mechanism as part of the integration tests we make use of [mailsac](https://mailsac.com/) as our test inbox for receiving the TOTP. The API key is part of the infra secrets and can be viewed/changed with `make test <print|edit>-infra-secrets`.

### Contract tests

The adviser sign up journey has a number of contract tests. These work similar to snapshot testing in Jest; a sign up is performed via Capybara and the payload that would be sent to the API is captured as the 'contract output'. If a change causes the payload to change the test will fail and you need to remove the previous snapshot (contract output) if the change is expected.

These output files are used as inputs into the API contract tests; we feed in the snapshot and capture the requests the API makes to the CRM, performing the same process). At the moment updating the input snapshots in the API is performed manually when something changes; ideally this would be automated in CI in the future.

## Linters

We have various linters in place to enforce code consistency; these will be ran automatically as part of CI, but you can run them locally/configure a pre-commit hook if you prefer.

### Ruby

Lint Ruby with `rubocop` (autofix with `rubocop -A`).

### Javascript

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

## Technical notes

There are a couple of aspects to be aware of when developing on the Get into Teaching website:

1. The `HtmlResponseTransformer` middleware does various sweeping changes to responses, primarily for image optimisation but also accessibility, errors and links. Its worth making yourself familiar with the middelware.
1. We use a static page cache for all of the Markdown pages on the website; this is **not enabled in development by default**. You can enable it with `rails dev:cache`. It is applied via the `PagesController` by default to content. There is also custom middleware to prevent any pages rendering a form from being cached (as the CSRF token would become invalid). The cache is cleared on deployment and the cached pages have a 5 minute TTL.
1. All images are optimised and converted to modern formats as part of the Docker build process. This means you can add a `png` image and it will be compressed, converted and presented automatically (via the `HtmlResponseTransformer` middleware).
1. Non-developers routinely contribute to the website by way of content changes; as such, there are several tests focused on this specifically (preventing absolute URLs being added, broken links, accessibility checks etc).
1. Assets are served by a separate host/instance. This is so we can have a different cache control policy in CloudFront for the static assets (i.e. cache them forever - the asset hash causes the browser to download again when these change).
1. All tracking pixels/analytics are served via GTM (and consent is handled in GTM as well).
1. Data pulled from the GiT API will be cached for up to 10 minutes; there is a 5m TTL of non-candidate data returned from the API and the API updates from the CRM every 5 minutes.
1. Not so much a technical point, but a domain quirk to be aware of; any teaching event can be flagged as 'online'. There is also a separate category/type of teaching event which is 'online'.
1. The sign up journeys leverage a `git_wizard` gem; its currently only used by the Get into Teaching website and Get an adviser service so it can be changed freely/without worry of effecting other teams. Soon only the Get into Teaching website will use this gem so we may want to bring it into the codebase for ease of maintenance.
