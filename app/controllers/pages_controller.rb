class PagesController < ApplicationController

  def scribble
    @page_title = 'Scribble Test'
    render template: "pages/scribble"
  end

  def privacy_policy
    @page_title = 'Privacy Policy'
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
  rescue ActionView::MissingTemplate
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

  def showblank
    render template: "content/#{params[:page]}", layout: "layouts/blank"
  rescue ActionView::MissingTemplate
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

private

  def content_template(requested_page)
    "content/#{requested_page}"
  end
end
