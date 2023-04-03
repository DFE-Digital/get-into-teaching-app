class PagesController < ApplicationController
  class InvalidTemplateName < RuntimeError; end

  before_action :init_funding_widget, only: %i[scholarships_and_bursaries scholarships_and_bursaries_search]

  MISSING_TEMPLATE_EXCEPTIONS = [
    ActionView::MissingTemplate,
    InvalidTemplateName,
  ].freeze

  PAGE_TEMPLATE_FILTER = %r{\A[a-zA-Z0-9][a-zA-Z0-9_\-/]*(\.[a-zA-Z]+)?\z}
  DYNAMIC_PAGE_PATHS = [
    "/train-to-be-a-teacher/if-you-have-a-degree", # Contains a form
    "/train-to-be-a-teacher/if-you-dont-have-a-degree", # Contains a form
    "/train-to-be-a-teacher/initial-teacher-training", # Contains a form
    "/help-and-support", #  Contains a form
    "/landing/how-much-do-teachers-get-paid", # Contains a form
    "/landing/how-much-do-teachers-get-paid-social", # Contains a form
    "/landing/how-to-become-a-teacher", # Contains a form
    "/landing/how-to-fund-your-teacher-training", # Contains a form
    "/landing/train-to-teach-if-you-have-a-degree", # Contains a form
    "/landing/home", # Contains a form
  ].freeze

  caches_page :cookies
  caches_page :show, unless: proc { |env| DYNAMIC_PAGE_PATHS.include?(env.request.path) }

  before_action :set_welcome_guide_info, if: -> { request.path.start_with?("/welcome") && (params[:subject] || params[:degree_status]) }
  rescue_from *MISSING_TEMPLATE_EXCEPTIONS, with: :rescue_missing_template

  PAGE_LAYOUTS = [
    "layouts/home",
    "layouts/accordion",
    "layouts/steps",
    "layouts/minimal",
    "layouts/stories/landing",
    "layouts/stories/list",
    "layouts/stories/story",
    "layouts/welcome",
    "layouts/category",
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
    render_page(params[:page])
  end

  # Avoid caching by rendering these pages manually:

  def scholarships_and_bursaries
    render_page("funding-and-support/scholarships-and-bursaries")
  end

  def scholarships_and_bursaries_search
    render_page("funding-and-support/scholarships-and-bursaries-search")
  end

  def welcome
    render_page("welcome")
  end

  def welcome_my_journey_into_teaching
    render_page("welcome/my-journey-into-teaching")
  end

  def tta_service
    raise ActionView::MissingTemplate if ENV["TTA_SERVICE_URL"].blank?

    url = ENV["TTA_SERVICE_URL"]
    if Rails.application.config.x.utm_codes && session[:utm]
      url += "?#{session[:utm].to_param}"
    end

    redirect_to(url, turbolinks: false, status: :moved_permanently, allow_other_host: true)
  end

private

  def init_funding_widget
    @funding_widget =
      if params[:funding_widget].blank?
        FundingWidget.new
      else
        FundingWidget.new(funding_widget_params).tap(&:valid?)
      end
  end

  def render_page(path)
    @page = ::Pages::Page.find content_template(path)

    (@page.ancestors.reverse + [@page]).each do |page|
      title = page.heading || page.title
      breadcrumb title, page.path if title.present?
    end

    render template: @page.template, layout: page_layout
  end

  def funding_widget_params
    params.require(:funding_widget).permit(:subject)
  end

  def set_welcome_guide_info
    wg_params = params.permit(:subject, :degree_status)

    session["welcome_guide"] = {
      "preferred_teaching_subject_id" => TeachingSubject.keyed_subjects[wg_params[:subject]&.to_sym],
      "degree_status_id" => OptionSet.lookup_const(:degree_status)[wg_params[:degree_status]&.to_sym],
    }
  end

  def page_layout
    layout = @page.frontmatter[:layout]
    return layout if PAGE_LAYOUTS.include?(layout)

    "layouts/content"
  end

  def content_template(path)
    "/#{filtered_page_template(path)}"
  end

  def filtered_page_template(path)
    path.to_s.tap do |page|
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
