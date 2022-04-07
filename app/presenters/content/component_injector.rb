module Content
  class ComponentInjector
    def initialize(type, params)
      @type = type
      @params = params
    end

    def component
      return unless @params

      klass = "Content::#{@type.camelize}Component".constantize
      klass.new(**@params.deep_symbolize_keys)
    end
  end
end
