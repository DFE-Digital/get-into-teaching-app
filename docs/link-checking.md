# Link checking

There are two kinds of link checks and they run in different contexts.

## Internal link checking

The internal link checks are reliant on our custom Rails routing rules so the
web application needs to be running. Because of this we run them in a
[RSpec Feature](https://relishapp.com/rspec/rspec-rails/docs/feature-specs/feature-spec).

### Running the internal link checker

Typically the internal link checks are run on a schedule and are tagged in
RSpec with the `onschedule` tag. We can use the tag to isolate them when
running.

```bash
bundle exec rspec --tag onschedule
```

The tag needs to be specified even if the file is run directly.

### Running the external link checker

External links are now tested using [Lychee](https://github.com/lycheeverse/lychee).

Install it using your package manager of choice or download the binary
[from GitHub](https://github.com/lycheeverse/lychee/releases) and make it
executable.

```bash
lychee --insecure --exclude-mail app/views/content
```
