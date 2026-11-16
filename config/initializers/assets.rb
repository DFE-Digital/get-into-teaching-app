Rails.application.config.assets.version = "1.0"

# Dart Sass compiles the stylesheet sources into app/assets/builds, which
# Propshaft serves. The sources themselves must not be served.
Rails.application.config.assets.excluded_paths << Rails.root.join("app/assets/stylesheets")

# Vendor files referenced by url() in the compiled CSS. The GOV.UK assets are
# addressed as /fonts/... and /images/... ($govuk-assets-path is "/"); the Font
# Awesome webfonts are addressed from the root ($fa-font-path is empty).
Rails.application.config.assets.paths << Rails.root.join("node_modules/govuk-frontend/dist/govuk/assets")
Rails.application.config.assets.paths << Rails.root.join("node_modules/@fortawesome/fontawesome-free/webfonts")
