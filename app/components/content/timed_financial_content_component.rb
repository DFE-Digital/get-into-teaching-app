# frozen_string_literal: true

module Content
  class TimedFinancialContentComponent < ViewComponent::Base
    def initialize(now: Time.current, default: { text: "" }, **conditional_branch_args)
      super
      @now = now
      @default = default
      @conditional_branch_args = conditional_branch_args.transform_keys(&:to_s) || {}
    end

    def call
      render_detail = conditional_branch_args.fetch(branch_key, default)

      if render_detail[:partial]
        @view_context.render partial: render_detail[:partial]
      else
        render_detail[:text]
      end
    end

  private

    attr_reader :now, :default, :conditional_branch_args

    def branch_key
      relevant_branch = content_dates.detect do |content_date|
        range = content_date[:valid_from]..content_date[:valid_to]
        now.in?(range)
      end
      return "default" unless relevant_branch

      relevant_branch[:key]
    end

    def content_dates
      [
        { key: "2026", valid_from: Time.zone.parse("2026-10-06"), valid_to: nil },
        { key: "2025", valid_from: nil, valid_to: Time.zone.parse("2026-09-28") },
      ]
    end
  end
end
