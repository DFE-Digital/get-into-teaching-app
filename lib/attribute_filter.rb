module AttributeFilter
  def self.filtered_json(obj)
    filters = Rails.application.config.filter_parameters
    param_filter = ActiveSupport::ParameterFilter.new(filters)
    param_filter.filter(obj.to_hash).to_json
  end
end
