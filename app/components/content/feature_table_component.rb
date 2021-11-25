module Content
  class FeatureTableComponent < ViewComponent::Base
    attr_reader :data, :title

    def initialize(data, title = nil)
      super

      @data = data
      @title = title

      fail(ArgumentError, "data must be present") unless data?
    end

    def wrapper_class
      klass = %w[feature-table]
      klass << "feature-table--with-title" if title
      klass.join(" ")
    end

    def title?
      title.present?
    end

  private

    def data?
      @data&.present?
    end
  end
end
