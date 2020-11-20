class PagesController < ApplicationController
  include StaticPages
  around_action :cache_static_page, only: %i[show]
  rescue_from ActionView::MissingTemplate, StaticPages::InvalidTemplateName, with: :rescue_missing_template

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
    render template: content_template, layout: page_layout
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

  def page_layout
    request.path == root_path ? "layouts/home" : "layouts/content"
  end

  def content_template
    "content/#{filtered_page_template}"
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
