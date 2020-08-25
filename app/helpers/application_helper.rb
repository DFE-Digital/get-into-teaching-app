module ApplicationHelper
  def analytics_body_tag(attributes = {}, &block)
    attributes = attributes.with_indifferent_access

    analytics = {
      "analytics-gtm-id" => ENV["GOOGLE_TAG_MANAGER_ID"],
      "analytics-pinterest-id" => ENV["PINTEREST_ID"],
      "analytics-snapchat-id" => ENV["SNAPCHAT_ID"],
      "analytics-facebook-id" => ENV["FACEBOOK_ID"],
      "analytics-hotjar-id" => ENV["HOTJAR_ID"],
      "snapchat-action" => "track",
      "snapchat-event" => "PAGE_VIEW",
      "facebook-action" => "track",
      "facebook-event" => "PageView",
    }

    attributes[:data] ||= {}
    attributes[:data] = attributes[:data].merge(analytics)

    attributes[:data][:controller] =
      "gtm pinterest snapchat facebook hotjar #{attributes[:data][:controller]}"

    content_tag :body, attributes, &block
  end

  def page_title(title, frontmatter)
    frontmatter ||= {}
    title || frontmatter["title"] || params[:page].to_s.humanize
  end

  def prefix_title(title)
    if title
      "Get into teaching: #{title}"
    else
      "Get into teaching"
    end
  end

  def header_image
    # FIXME: needs to parse frontpatter
    "media/images/main-header.jpg"
  end

  def hero_image_path(imgpath)
    if imgpath =~ %r{^/assets/}
      imgpath
    else
      asset_pack_path(imgpath)
    end
  end

  def fa_icon(icon_name, *additional_classes)
    classes = ["fas", "fa-#{icon_name}"] + additional_classes
    content_tag :i, "", class: classes.join(" ")
  end
  alias_method :fas, :fa_icon

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

  def tta_service_link(opts = nil, &block)
    return nil if ENV["TTA_SERVICE_URL"].blank?

    url = ENV["TTA_SERVICE_URL"]
    if Rails.application.config.x.utm_codes && session[:utm]
      url += "?" + session[:utm].to_param
    end

    link_to url, opts, &block
  end
end
