module ApplicationHelper
  def analytics_body_tag(attributes = {}, &block)
    attributes[:data] ||= {}
    attributes[:data][:controller] ||= ""
    attributes[:data][:controller] << " gtm-consent"

    tag.body(**attributes, &block)
  end

  def gtm_enabled?
    ENV["GTM_ID"].present?
  end

  def page_title(title, frontmatter)
    frontmatter ||= {}
    title || frontmatter["title"] || params[:page].to_s.humanize
  end

  def prefix_title(title)
    if title
      "#{title} | Get Into Teaching"
    else
      "Get Into Teaching"
    end
  end

  # FA supports several styles:
  # fas = solid, fab = brand, far = regular, fal = light, fad = duotone
  # https://fontawesome.com/how-to-use/on-the-web/referencing-icons/basic-use
  def fa_icon(icon_name, *additional_classes, style: "fas")
    classes = [style, "fa-#{icon_name}"] + additional_classes
    tag.span("", class: classes)
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

  def back_link(path = :back, text: "Back", **options)
    options[:class] = "govuk-back-link #{options[:class]}".strip

    link_to text, path, **options
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

  def google_optimize_script
    paths = google_optimize_config[:paths]
    id = ENV["GOOGLE_OPTIMIZE_ID"]

    return unless paths.present? && id.present?

    javascript_pack_tag "google_optimize", 'data-turbo-track': "reload", data: {
      "google-optimize-id": id,
      "google-optimize-paths": paths,
    }
  end

  def google_optimize_config
    @@google_optimize_config ||=
      YAML.safe_load(File.read(Rails.root.join("config/google_optimize.yml")))
        .deep_symbolize_keys
  end

  def sentry_dsn
    return nil if Rails.env.production?

    Sentry.configuration.dsn&.to_s
  end
end
