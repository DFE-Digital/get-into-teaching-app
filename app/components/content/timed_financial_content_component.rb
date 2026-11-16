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

    # Resolves timed content for non-HTML contexts such as document titles and
    # meta tags. It deliberately does not render the component, so Rails does
    # not add development template annotations to the returned text.
    def self.resolve_text(params: {}, **component_args)
      new(**component_args).resolve_text(params: params)
    end

    def initialize(now: Time.zone.now, branch: nil, default: { text: "" }, format: "html", **conditional_branch_args)
      super()
      @now = now
      @branch = branch
      @default = default
      @format = format.to_s.inquiry
      @conditional_branch_args = conditional_branch_args.transform_keys(&:to_s) || {}
    end

    def call
      render_detail = selected_render_detail(params: view_context.params)
      if render_detail[:partial]
        @view_context.render partial: render_detail[:partial]
      else
        render_text(render_detail[:text])
      end
    end

    def resolve_text(params: {})
      text = selected_render_detail(params: params)[:text]
      text.present? ? substitute_values(text).strip : ""
    end

  private

    attr_reader :now, :branch, :default, :conditional_branch_args, :format

    def render_text(text)
      return "" if text.blank?
      return text if text.html_safe?
      return substitute_values(text).strip if format.text?

      Kramdown::Document.new(substitute_values(text)).to_html.strip.html_safe
    end

    def selected_render_detail(params:)
      conditional_branch_args.fetch(selected_branch_key(params: params), default)
    end

    def selected_branch_key(params:)
      override_branch_key(params: params) || override_now_key(params: params) || branch_key(now)
    end

    def overrides_enabled? = !Rails.env.production?

    def override_now_key(params:)
      return unless overrides_enabled?

      now_param = params[:now]
      return if now_param.blank?

      override_now = Time.zone.parse(now_param)
      override_now && branch_key(override_now)
    rescue ArgumentError, TypeError
      nil
    end

    def override_branch_key(params:)
      return unless overrides_enabled?

      key = (params[:branch].presence || branch)&.to_s
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
