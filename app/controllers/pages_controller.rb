class PagesController < ApplicationController
  class InvalidTemplateName < RuntimeError; end

  before_action :init_funding_widget, only: %i[scholarships_and_bursaries scholarships_and_bursaries_search]

  MISSING_TEMPLATE_EXCEPTIONS = [
    ActionView::MissingTemplate,
    InvalidTemplateName,
  ].freeze

  PAGE_TEMPLATE_FILTER = %r{\A[a-zA-Z0-9][a-zA-Z0-9_\-/]*(\.[a-zA-Z]+)?\z}

  caches_page :cookies
  caches_page :show

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
    url = if ActiveModel::Type::Boolean.new.cast(ENV["GET_AN_ADVISER"])
            adviser_sign_up_url
          else
            adviser_service_url
          end

    if Rails.application.config.x.utm_codes && session[:utm]
      url += "?#{session[:utm].to_param}"
    end

    redirect_to(url, turbolinks: false, status: :moved_permanently, allow_other_host: true)
  end

private

  def adviser_sign_up_url
    teacher_training_adviser_step_path(:start)
  end

  def adviser_service_url
    raise ActionView::MissingTemplate if ENV["TTA_SERVICE_URL"].blank?

    ENV["TTA_SERVICE_URL"]
  end

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
      "preferred_teaching_subject_id" => Crm::TeachingSubject.keyed_subjects[wg_params[:subject]&.to_sym],
      "degree_status_id" => Crm::OptionSet.lookup_const(:degree_status)[wg_params[:degree_status]&.to_sym],
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
