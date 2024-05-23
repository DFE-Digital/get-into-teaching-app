module ApplicationHelper
  def body_tag(attributes = {}, &block)
    attributes[:data] ||= {}

    attributes[:data][:controller] ||= ""
    (attributes[:data][:controller] << " link table").strip!

    attributes[:data]["link-target"] = "content"
    attributes[:data]["link-asset-url-value"] = ENV["APP_ASSETS_URL"]

    attributes[:class] ||= ""
    (attributes[:class] <<= " govuk-template__body govuk-body").strip!

    attributes[:id] = "body"

    tag.body(**attributes, &block)
  end

  def main_tag(attributes = {}, &block)
    attributes[:id] = "main-content"
    attributes[:tabindex] = -1
    attributes[:class] = "#{attributes[:class]} tab-after-nav-menu".strip
    tag.main(**attributes, &block)
  end

  def gtm_enabled?
    ENV["GTM_ID"].present?
  end

  def page_title(title, frontmatter)
    frontmatter ||= {}
    title || frontmatter["title"] || params[:page].to_s.humanize
  end

  def suffix_title(title)
    if title
      "#{title} | Get Into Teaching GOV.UK"
    else
      "Get Into Teaching GOV.UK"
    end
  end

  def human_boolean(boolean)
    boolean ? "Yes" : "No"
  end

  # FA supports several styles:
  # fas = solid, fab = brand, far = regular, fal = light, fad = duotone
  # https://fontawesome.com/how-to-use/on-the-web/referencing-icons/basic-use
  def fa_icon(icon_name, *additional_classes, style: "fas")
    classes = [style, "fa-#{icon_name}"] + additional_classes
    tag.span("", class: classes, "aria-hidden": true)
  end

  def fas_icon(*args)
    fa_icon(*args, style: "fas")
  end

  def fab_icon(*args)
    fa_icon(*args, style: "fab")
  end

  def govuk_form_for(*args, **options, &block)
    merged = options.dup
    merged[:builder] = GOVUKDesignSystemFormBuilder::FormBuilder
    merged[:html] ||= {}
    merged[:html][:novalidate] = true

    form_for(*args, **merged, &block)
  end

  def internal_referer
    referer = request.referer

    return unless referer.present? && referer.start_with?(root_url)

    referer.gsub(root_url, root_path)
  end

  def replace_bau_cookies_link(html_content)
    html_content&.gsub \
      ' href="https://getintoteaching.education.gov.uk/how-we-use-your-information"',
      " href=\"#{cookies_path}\""
  end

  def privacy_page?(path)
    ["/cookie_preference", "/cookies", "/privacy-policy"].include?(path)
  end

  def sentry_dsn
    return nil if Rails.env.production?

    Sentry.configuration.dsn&.to_s
  end

  def content_footer_kwargs(front_matter)
    defaults = { talk_to_us: true, feedback: false }
    defaults.merge(front_matter.symbolize_keys.slice(:talk_to_us, :feedback))
  end
end
