module Events
  class TypeDescriptionComponent < ViewComponent::Base
    attr_accessor :type

    def initialize(type)
      super

      @type = type
    end

    def description
      t("event_types.#{type}.description.long")
    end

    def type_name_plural
      t("event_types.#{type}.name.plural")
    end

    def event_type_icon
      icon_class = %(icon-#{type_name_singular.parameterize})
      tag.div(class: icon_class)
    end

    def read_more_href
      event_category_path(type_name_plural.parameterize)
    end

  private

    def type_name_singular
      t("event_types.#{type}.name.singular")
    end
  end
end
