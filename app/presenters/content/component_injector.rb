module Content
  class ComponentInjector
    CTA_PARENT_NAMESPACE = "cta_".freeze

    def initialize(type_string, params)
      @type = full_type(type_string)
      @params = params
    end

    def full_type(type_string)
      return unless type_string

      if type_string.starts_with?(CTA_PARENT_NAMESPACE)
        "CallsToAction::#{type_string.sub(CTA_PARENT_NAMESPACE, '').camelize}Component"
      else
        "Content::#{type_string.camelize}Component"
      end
    end

    def component
      return unless @params

      klass = @type.constantize
      klass.new(**@params.deep_symbolize_keys)
    end
  end
end
