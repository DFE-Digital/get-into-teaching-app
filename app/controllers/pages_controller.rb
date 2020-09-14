class PagesController < ApplicationController
  include StaticPages
  around_action :cache_static_page, only: %i[show]
  rescue_from ActionView::MissingTemplate, with: :rescue_missing_template

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

  def show
    render template: content_template(params[:page]), layout: "layouts/content"
  end

  def showblank
    render template: "content/#{params[:page]}", layout: "layouts/blank"
  end

  def tta_service
    raise ActionView::MissingTemplate if ENV["TTA_SERVICE_URL"].blank?

    url = ENV["TTA_SERVICE_URL"]
    if Rails.application.config.x.utm_codes && session[:utm]
      url += "?" + session[:utm].to_param
    end

    redirect_to url
  end

private

  def content_template(requested_page)
    "content/#{requested_page}"
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
