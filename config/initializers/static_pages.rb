Rails.application.config.x.static_pages.tap do |config|
  if File.exist?("/etc/get-into-teaching-content-sha")
    config.etag = [
      File.read("/etc/get-into-teaching-app-sha"),
      File.read("/etc/get-into-teaching-content-sha"),
    ]

    config.last_modified =
      Time.parse(File.read("/etc/get-into-teaching-content-build-time")).utc
    config.expires_in = 1.minute
  else
    config.etag = nil
    config.last_modified = nil
    config.expires_in = nil
  end
end
