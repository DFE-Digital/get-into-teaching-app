class Healthcheck
  delegate :to_json, to: :to_h

  def app_sha
    read_file "/etc/get-into-teaching-app-sha"
  end

  def content_sha
    read_file "/etc/get-into-teaching-content-sha"
  end

  def to_h
    {
      app_sha: app_sha,
      content_sha: content_sha,
    }
  end

private

  def read_file(file)
    File.read(file).strip
  rescue Errno::ENOENT
    nil
  end
end
