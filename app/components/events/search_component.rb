module Events
  class SearchComponent < ViewComponent::Base
    attr_accessor :search, :path

    def initialize(search, path)
      @search = search
      @path   = path
    end

    def input_field_classes(field)
      error_class = "search-for-events__content__error"

      %w[search-for-events__content__input].tap do |classes|
        classes << error_class if search.errors[field].any?
      end
    end
  end
end
