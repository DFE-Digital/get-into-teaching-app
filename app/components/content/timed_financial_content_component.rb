# frozen_string_literal: true

module Content
  class TimedFinancialContentComponent < ViewComponent::Base
    def self.content_dates
      content_times_path = Rails.root.join("config/financial_content_times.yml")
      @content_dates ||= YAML.safe_load_file(content_times_path).fetch("financial_content_times").map do |entry|
        {
          key: entry["key"].to_s,
          valid_from: entry["valid_from"] && Time.zone.parse(entry["valid_from"]),
          valid_to: entry["valid_to"] && Time.zone.parse(entry["valid_to"]),
        }
      end
    end

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
      relevant_branch = self.class.content_dates.detect do |content_date|
        range = content_date[:valid_from]..content_date[:valid_to]
        now.in?(range)
      end
      return "default" unless relevant_branch

      relevant_branch[:key]
    end
  end
end
