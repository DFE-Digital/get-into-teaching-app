module ApiModelConvertable
  extend ActiveSupport::Concern

  def convert_attributes_from_api_model(api_model)
    api_model
      .to_hash
      .transform_keys { |k| k.to_s.underscore }
      .filter { |k| in_attribute_names?(k) }
  end

  def convert_attributes_for_api_model
    attributes
      .filter { |k| in_attribute_names?(k) }
      .transform_keys { |k| k.to_s.camelize(:lower) }
      .filter { |_, v| v.presence }
  end

private

  def in_attribute_names?(key)
    attribute_names.include?(key)
  end
end
