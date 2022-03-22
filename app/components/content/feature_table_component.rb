module Content
  class FeatureTableComponent < ViewComponent::Base
    attr_reader :data, :title, :heading_tag

    def initialize(data, title = nil, heading_tag: "h3")
      super

      @data = data
      @title = title
      @heading_tag = heading_tag

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
