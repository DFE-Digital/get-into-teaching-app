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

    def initialize(now: Time.zone.now, branch: nil, default: { text: "" }, **conditional_branch_args)
      super
      @now = now
      @branch = branch
      @default = default
      @conditional_branch_args = conditional_branch_args.transform_keys(&:to_s) || {}
    end

    def call
      render_detail = conditional_branch_args.fetch(selected_branch_key, default)
      if render_detail[:partial]
        @view_context.render partial: render_detail[:partial]
      else
        render_detail[:text]
      end
    end

  private

    attr_reader :now, :branch, :default, :conditional_branch_args

    # An explicit branch override wins over the date-based selection, so we can
    # force a branch for debugging - e.g. ?branch=2026 - without moving the clock.
    def selected_branch_key
      override_branch_key || override_now_key || branch_key(now)
    end

    def override_now_key
      return unless Rails.env.local?

      now_param = view_context.params[:now]
      return if now_param.blank?

      # A malformed param (e.g. ?now=broken) parses to nil or raises; either way
      # fall through to the date-based selection rather than erroring the page.
      override_now = Time.zone.parse(now_param)
      override_now && branch_key(override_now)
    rescue ArgumentError
      nil
    end

    # The override can come from the `branch` URL param or the `branch:`
    # argument. The param takes precedence, mirroring how `now` is handled.
    def override_branch_key
      return unless Rails.env.local?

      override = view_context.params[:branch].presence || branch
      override&.to_s
    end

    def branch_key(local_now)
      relevant_branch = self.class.content_dates.detect do |content_date|
        range = content_date[:valid_from]..content_date[:valid_to]
        local_now.in?(range)
      end
      return "default" unless relevant_branch

      relevant_branch[:key]
    end
  end
end
