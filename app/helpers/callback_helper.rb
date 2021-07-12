module CallbackHelper
  def callback_options(quotas)
    quotas_by_day(quotas).transform_values do |quotas_on_day|
      quotas_on_day.map do |quota|
        start_at_in_time_zone = quota.start_at.in_time_zone.to_formatted_s(:govuk_time_with_period)
        end_at_in_time_zone = quota.end_at.in_time_zone.to_formatted_s(:govuk_time_with_period)

        ["#{start_at_in_time_zone} - #{end_at_in_time_zone}", quota.start_at]
      end
    end
  end

  def quotas_by_day(quotas)
    quotas.group_by do |quota|
      quota.start_at.in_time_zone.to_date.to_formatted_s(:govuk_date_long)
    end
  end
end
