class Healthcheck
  delegate :to_json, to: :to_h

  def to_h
    {
      app_sha: app_sha,
      content_sha: content_sha,
      api: test_api,
      redis: test_redis,
      postgres: test_postgresql,
    }
  end

  def test_postgresql
    ApplicationRecord.connection
    ApplicationRecord.connected?
  rescue RuntimeError
    false
  end

  def app_sha
    read_file "/etc/get-into-teaching-app-sha"
  end

  def content_sha
    read_file "/etc/get-into-teaching-content-sha"
  end

  def test_api
    GetIntoTeachingApiClient::LookupItemsApi.new.get_teaching_subjects
    true
  rescue Faraday::Error, GetIntoTeachingApiClient::ApiError
    false
  end

  def test_redis
    return nil unless ENV["REDIS_URL"]

    $redis.ping == "PONG"
  rescue Redis::CannotConnectError
    false
  rescue RuntimeError
    false
  end

private

  def read_file(file)
    File.read(file).strip
  rescue Errno::ENOENT
    nil
  end
end
