module Events
  class SearchComponent < ViewComponent::Base
    BLANK_MONTH_TEXT = "All months".freeze
    FILTERABLE_MONTHS_COUNT = 6

    attr_accessor :search, :path, :include_type, :heading, :allow_blank_month

    def initialize(search, path, include_type: true, heading: "Search for events", allow_blank_month: false)
      super

      @search            = search
      @path              = path
      @include_type      = include_type
      @heading           = heading
      @allow_blank_month = allow_blank_month
    end

    def input_field_classes(field)
      return "form__field--error" if search.errors[field].any?
    end

    def month_args
      if allow_blank_month
        { include_blank: BLANK_MONTH_TEXT }
      else
        {}
      end
    end

    def filterable_months
      search.available_months.take(FILTERABLE_MONTHS_COUNT)
    end

    def error_messages
      search.errors.messages.values.flatten
    end
  end
end
