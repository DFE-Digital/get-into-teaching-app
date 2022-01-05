module ApiModelConvertible
  extend ActiveSupport::Concern

  included do
    def self.convert_attributes_from_api_model(api_model)
      api_model
        .to_hash
        .transform_keys { |k| k.to_s.underscore }
        .filter { |k| attribute_names.include?(k) }
        .with_indifferent_access
    end
  end

  def convert_attributes_for_api_model
    attributes
      .filter { |k| attribute_names.include?(k) }
      .filter { |_, v| v.presence }
      .with_indifferent_access
  end
end
