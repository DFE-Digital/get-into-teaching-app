class PagesController < ApplicationController
  include StaticPageCache
  cache_actions :show, :privacy_policy, :cookies

  class InvalidTemplateName < RuntimeError; end

  MISSING_TEMPLATE_EXCEPTIONS = [
    ActionView::MissingTemplate,
    InvalidTemplateName,
  ].freeze

  PAGE_TEMPLATE_FILTER = %r{\A[a-zA-Z0-9][a-zA-Z0-9_\-/]*(\.[a-zA-Z]+)?\z}.freeze

  before_action :set_welcome_guide_info, if: -> { request.path.start_with?("/welcome") && request.query_parameters.any? }
  rescue_from *MISSING_TEMPLATE_EXCEPTIONS, with: :rescue_missing_template

  PAGE_LAYOUTS = [
    "layouts/home",
    "layouts/accordion",
    "layouts/steps",
    "layouts/stories/landing",
    "layouts/stories/list",
    "layouts/stories/story",
    "layouts/welcome",
    "layouts/campaigns/landing_page_with_hero_nav",
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
    render template: "pages/cookies", layout: "disclaimer"
  end

  def show
    @page = ::Pages::Page.find content_template

    (@page.ancestors.reverse + [@page]).each do |page|
      breadcrumb page.title, page.path if @page.title.present?
    end

    if @page.path.match?(/funding-your-training/)
      @funding_widget =
        if params[:funding_widget].blank?
          FundingWidget.new
        else
          FundingWidget.new(funding_widget_params).tap(&:valid?)
        end
    end

    render template: @page.template, layout: page_layout
  end

  def tta_service
    raise ActionView::MissingTemplate if ENV["TTA_SERVICE_URL"].blank?

    url = ENV["TTA_SERVICE_URL"]
    if Rails.application.config.x.utm_codes && session[:utm]
      url += "?" + session[:utm].to_param
    end

    redirect_to(url, turbolinks: false, status: :moved_permanently)
  end

private

  def funding_widget_params
    params.require(:funding_widget).permit(:subject)
  end

  def set_welcome_guide_info
    session["welcome_guide"] = request.query_parameters.slice("preferred_teaching_subject_id", "degree_status_id")
  end

  def page_layout
    layout = @page.frontmatter[:layout]
    return layout if PAGE_LAYOUTS.include?(layout)

    "layouts/content"
  end

  def content_template
    "/#{filtered_page_template}"
  end

  def filtered_page_template(page_param = :page)
    params[page_param].to_s.tap do |page|
      raise InvalidTemplateName if page !~ PAGE_TEMPLATE_FILTER
    end
  end

  def rescue_missing_template
    respond_to do |format|
      format.html do
        render \
          template: "errors/not_found",
          layout: "application",
          status: :not_found
      end

      format.all do
        render status: :not_found, body: nil
      end
    end
  end
end
