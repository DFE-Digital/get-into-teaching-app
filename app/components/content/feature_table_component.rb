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

    def wrapper
      wrapper_class = %w[feature-table]
      wrapper_class << "feature-table--with-title" if title
      tag.div(class: wrapper_class.join(" ")) { yield }
    end

    def table
      tag.table("aria-label": description) { yield }
    end

    def heading
      return nil if title.blank?

      tag.h2(title, class: "strapline strapline--blue")
    end

    def desktop_rows
      safe_join(
        data.map do |key, value|
          tag.tr do
            tag.th(key) + tag.td(value)
          end
        end,
      )
    end

    def mobile_rows
      safe_join(
        data.map do |key, value|
          tag.tr {
            tag.th(key)
          } +
          tag.tr do
            tag.td(value)
          end
        end,
      )
    end

  private

    def data?
      @data&.present?
    end
  end
end
