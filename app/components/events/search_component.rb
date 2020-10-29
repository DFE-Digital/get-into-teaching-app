module Events
  class SearchComponent < ViewComponent::Base
    attr_accessor :search, :path, :include_type, :heading

    def initialize(search, path, include_type: true, heading: "Search for events")
      @search       = search
      @path         = path
      @include_type = include_type
      @heading      = heading
    end

    def input_field_classes(field)
      error_class = "search-for-events__content__error"

      %w[search-for-events__content__input].tap do |classes|
        classes << error_class if search.errors[field].any?
      end
    end
  end
end
