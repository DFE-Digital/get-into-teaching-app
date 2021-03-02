module CircuitBreaker
  class NotAvailablePathMissingError < RuntimeError; end

  extend ActiveSupport::Concern

  included do
    rescue_from GetIntoTeachingApiClient::CircuitBrokenError, with: :redirect_to_not_available
  end

protected

  def redirect_to_not_available
    redirect_to(not_available_path)
  end

  def not_available_path
    raise NotAvailablePathMissingError, "#not_available_path hasn't been overridden"
  end
end
