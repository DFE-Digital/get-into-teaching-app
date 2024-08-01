class Chat
  delegate :to_json, to: :to_h

  def to_h
    {
      skillid: skillid,
      available: available,
      status_age: status_age,
    }
  end

private

  def skillid
    availability["skillid"] if availability
  end

  def available
    availability ? availability["available"] : false
  end

  def status_age
    availability["status_age"] if availability
  end

  def availability
    return if availability_api_uri.blank?

    @availability ||=
      begin
        response = Faraday.get(availability_api_uri)
        JSON.parse(response.body) if response.success?
      rescue Faraday::ConnectionFailed
        nil
      end
  end

  def availability_api_uri
    ENV.fetch("CHAT_AVAILABILITY_API", nil)
  end
end
