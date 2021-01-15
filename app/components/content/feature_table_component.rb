module Content
  class FeatureTableComponent < ViewComponent::Base
    attr_reader :data, :title, :description

    def initialize(data, description, title = nil)
      @data = data
      @description = description
      @title = title

      fail(ArgumentError, "data must be present") unless data?
      fail(ArgumentError, "description must be present") if description.blank?
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
