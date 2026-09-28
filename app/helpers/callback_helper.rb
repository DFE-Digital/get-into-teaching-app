module CallbackHelper
  include CoerceToLondonTime

  Quota = Data.define(:start_at, :end_at, :start_at_local_time, :end_at_local_time, :day)

  def callback_options(quotas)
    quotas_by_day(quotas).transform_values do |quotas_on_day|
      quotas_on_day.map do |quota|
        ["#{quota.start_at_local_time} to #{quota.end_at_local_time}", quota.start_at]
      end
    end
  end

  def quotas_by_day(quotas)
    quotas.map { |quota|
      Quota.new(
        start_at: quota.start_at,
        end_at: quota.end_at,
        start_at_local_time: coerce_to_london_time(quota.start_at).in_time_zone.to_formatted_s(:govuk_time_with_period),
        end_at_local_time: coerce_to_london_time(quota.end_at).in_time_zone.to_formatted_s(:govuk_time_with_period),
        day: coerce_to_london_time(quota.start_at).in_time_zone.to_date.to_formatted_s(:govuk_date_long),
      )
    }.group_by(&:day)
  end

  def callback_available?
    Callbacks::Steps::Callback.callback_booking_quotas.any?
  end
end
