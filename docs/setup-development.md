## Setting up the app in development

1. Run `bundle install` to install the gem dependencies
2. Run `yarn` to install node dependencies
3. Run `az login` and then `make local set-local-env` to populate development secrets
4. Run `bundle exec rails server` to launch the app on http://localhost:3000
5. Run `./bin/webpack-dev-server` in a separate shell for faster compilation of assets

## Copy the content your local machine.
Content for this website is stored in a seperate repo and is added in by the CI/CD pipeline.
You will need to do this manually to have the content available on your local development environment.

1. Clone the following repo: https://github.com/DFE-Digital/get-into-teaching-content
2. Copy the `content` folder from this repo and merge it into `app/views/content`

Alternatively, create a [symlink](https://en.wikipedia.org/wiki/Symbolic_link)
from `apps/views/content` to the location of your content directory by changing
to your `app/views` directory and running `ln -s content /the/path/to/your/content/directory`.
