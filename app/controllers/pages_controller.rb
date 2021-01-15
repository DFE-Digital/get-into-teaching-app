class PagesController < ApplicationController
  include StaticPages
  delegate :template_exists?, to: :lookup_context
  around_action :cache_static_page, only: %i[show]
  rescue_from *MISSING_TEMPLATE_EXCEPTIONS, with: :rescue_missing_template

  PAGE_LAYOUTS = [
    "layouts/accordion",
    "layouts/stories/landing",
    "layouts/stories/list",
    "layouts/stories/story",
  ].freeze

  def privacy_policy
    @page_title = "Privacy Policy"
    policy_id = params[:id]

    @privacy_policy = if policy_id
                        GetIntoTeachingApiClient::PrivacyPoliciesApi.new.get_privacy_policy(policy_id)
                      else
                        GetIntoTeachingApiClient::PrivacyPoliciesApi.new.get_latest_privacy_policy
                      end

    render template: "pages/privacy_policy"
  end

  def cookies
    render template: "pages/cookies"
  end

  def show
    render_not_found && return if directly_requesting_index_page?

    @page = Pages::Page.find content_template
    render template: @page.template, layout: page_layout
  end

  def showblank
    render template: content_template, layout: "layouts/blank"
  end

  def tta_service
    raise ActionView::MissingTemplate if ENV["TTA_SERVICE_URL"].blank?

    url = ENV["TTA_SERVICE_URL"]
    if Rails.application.config.x.utm_codes && session[:utm]
      url += "?" + session[:utm].to_param
    end

    redirect_to(url, turbolinks: false)
  end

private

  def directly_requesting_index_page?
    params[:page].end_with?("/index")
  end

  def page_layout
    layout = @page.frontmatter[:layout]
    return layout if PAGE_LAYOUTS.include?(layout)

    request.path == root_path ? "layouts/home" : "layouts/content"
  end

  def content_template
    template = "/#{filtered_page_template}"
    return template if template_exists?("#{Pages::Page::TEMPLATES_FOLDER}/#{template}")

    "#{template}/index"
  end

  def rescue_missing_template
    respond_to do |format|
      format.html do
        render \
          template: "errors/not_found",
          status: :not_found
      end

      format.all do
        render status: :not_found, body: nil
      end
    end
  end
end
