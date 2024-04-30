class PagesController < ApplicationController
  class InvalidTemplateName < RuntimeError; end
  class InvalidPrivacyPolicy < RuntimeError; end

  before_action :init_funding_widget, only: %i[scholarships_and_bursaries scholarships_and_bursaries_search]

  MISSING_TEMPLATE_EXCEPTIONS = [
    ActionView::MissingTemplate,
    InvalidTemplateName,
  ].freeze

  PAGE_TEMPLATE_FILTER = %r{\A[a-zA-Z0-9][a-zA-Z0-9_\-/]*(\.[a-zA-Z]+)?\z}
  PRIVACY_POLICY_ID_FILTER = %r{^[0-9a-fA-F]{8}\b-[0-9a-fA-F]{4}\b-[0-9a-fA-F]{4}\b-[0-9a-fA-F]{4}\b-[0-9a-fA-F]{12}$}

  caches_page :cookies
  caches_page :show

  before_action :set_welcome_guide_info, if: -> { request.path.start_with?("/welcome") && (params[:subject] || params[:degree_status]) }
  rescue_from *MISSING_TEMPLATE_EXCEPTIONS, with: :rescue_missing_template
  rescue_from InvalidPrivacyPolicy, with: :rescue_invalid_privacy_policy

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

    raise InvalidPrivacyPolicy if policy_id && policy_id !~ PRIVACY_POLICY_ID_FILTER

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

  def campus_mailing_list
    render_page("landing/campus-mailing-list")
  end

  def get_the_most_from_events
    render_page("events/get-the-most-from-events")
  end

  def what_happens_at_events_transcript
    render_page("events/what-happens-at-events-transcript")
  end

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

  def authenticate?
    # restrict the /values page to any user who has a login
    %w[values].include?(action_name) || super
  end

  def values
    # restrict the /values page to any user who has a login
    render_forbidden if session[:user].blank?
    render template: "pages/values", layout: "content"
  end

private

  def adviser_sign_up_url
    teacher_training_adviser_step_path(:identity)
  end

  def init_funding_widget
    if params[:funding_widget].present?
      @funding_widget = FundingWidget.new(funding_widget_params)
      @funding_widget.valid?
      @funding_widget.content_errors.each { |e| add_content_error(e) }
      @content_errors_title = "There is a problem" unless @funding_widget.valid?
    else
      @funding_widget = FundingWidget.new
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

  def rescue_invalid_privacy_policy
    respond_to do |format|
      format.html do
        render \
          template: "errors/bad_request",
          layout: "application",
          status: :bad_request
      end

      format.all do
        render status: :bad_request, body: nil
      end
    end
  end
end
