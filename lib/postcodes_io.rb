class PostcodesIO
  require "uri"

  BASE_URI = "https://api.postcodes.io/postcodes".freeze
  CACHE_TTL = 5.minutes
  LookupFailed = Class.new(StandardError)

  attr_reader :postcode

  def initialize(postcode)
    @postcode = postcode.to_s.strip.upcase
    super()
  end

  def district_or_region
    # We cache repeated calls for the same postcode for a short period.
    Rails.cache.fetch(cache_key, expires_in: CACHE_TTL) do
      response = Faraday.get("#{BASE_URI}/#{encoded_postcode}")

      raise LookupFailed unless response.success?

      result = JSON.parse(response.body).fetch("result")
      result["admin_district"].presence || result["region"]
    end
  rescue Faraday::Error, JSON::ParserError, KeyError, LookupFailed
    nil
  end

private

  def encoded_postcode
    URI.encode_uri_component(postcode)
  end

  def postcode_area
    postcode.split(/\s+/).first
  end

  def cache_key
    ["postcodes_io", "district_or_region", postcode]
  end
end
