module UtmCodes
  include ActiveSupport::Concern

  def record_utm_codes
    return unless Rails.application.config.x.utm_codes && request.get?

    utm_codes = params.keys.select { |k| k =~ /\Autm_/i }
    return if utm_codes.empty?

    session[:utm] = params.permit(*utm_codes).to_hash
  end
end
