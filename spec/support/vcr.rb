VCR.configure do |config|
  config.cassette_library_dir = "spec/vcr"
  config.hook_into :faraday
  config.configure_rspec_metadata!
  config.before_record do |i|
    i.response.body.force_encoding("UTF-8")
  end

  # Use global cassettes unless the test specifies a custom casette.
  config.around_http_request(->(req) { req.method == :get && VCR.turned_on? }) do |request|
    if VCR.cassettes.any?
      request.proceed
    else
      VCR.use_cassette(request.uri, &request)
    end
  end
end
