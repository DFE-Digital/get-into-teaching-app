# frozen_string_literal: true

module Content
  class TimedFinancialContentComponent < ViewComponent::Base
    include Values

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

    def initialize(now: Time.zone.now, branch: nil, default: { text: "" }, format: "html", **conditional_branch_args)
      super
      @now = now
      @branch = branch
      @default = default
      @format = format.to_s.inquiry
      @conditional_branch_args = conditional_branch_args.transform_keys(&:to_s) || {}
    end

    def call
      render_detail = conditional_branch_args.fetch(selected_branch_key, default)
      if render_detail[:partial]
        @view_context.render partial: render_detail[:partial]
      else
        render_text(render_detail[:text])
      end
    end

  private

    attr_reader :now, :branch, :default, :conditional_branch_args, :format

    def render_text(text)
      return "" if text.blank?
      return text if text.html_safe?
      return substitute_values(text).strip if format.text?

      Kramdown::Document.new(substitute_values(text)).to_html.strip.html_safe
    end

    def selected_branch_key
      override_branch_key || override_now_key || branch_key(now)
    end

    def overrides_enabled? = !Rails.env.production?

    def override_now_key
      return unless overrides_enabled?

      now_param = view_context.params[:now]
      return if now_param.blank?

      override_now = Time.zone.parse(now_param)
      override_now && branch_key(override_now)
    rescue ArgumentError, TypeError
      nil
    end

    def override_branch_key
      return unless overrides_enabled?

      key = (view_context.params[:branch].presence || branch)&.to_s
      key if key && (conditional_branch_args.key?(key) || key == "default")
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
