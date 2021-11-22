module CallbackBookingQuotas
  def callback_booking_quotas
    quotas = GetIntoTeachingApiClient::CallbackBookingQuotasApi.new.get_callback_booking_quotas
    quotas.reject do |quota|
      time_away = quota.start_at.utc - Time.zone.now.utc
      time_away <= 1.hour
    end
  end
end
