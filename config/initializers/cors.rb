# We don't allow CORS but use the Rack::Cors middleware to correctly
# serve the preflight OPTIONS requests from browsers.
Rails.application.config.middleware.insert_before 0, Rack::Cors
