class PagesController < ApplicationController
  def home
    render template: "pages/home"
  end

  def scribble
    render template: "pages/scribble"
  end

  def event
    render template: "pages/events/event"
  end

  def eventschool
    render template: "pages/events/eventschool"
  end

  def events_ttt
    render template: "pages/events/events_ttt"
  end

  def events_online
    render template: "pages/events/events_online"
  end

  def events_school
    render template: "pages/events/events_school"
  end

  def mailingregistration
    render template: "pages/mailinglist/registration/step#{params[:step_number]}"
  end

  def privacy_policy
    policy_id = params[:id]

    @privacy_policy = if policy_id
                        GetIntoTeachingApiClient::PrivacyPoliciesApi.new.get_privacy_policy(policy_id)
                      else
                        GetIntoTeachingApiClient::PrivacyPoliciesApi.new.get_latest_privacy_policy
                      end

    render template: "pages/privacy_policy"
  end

  def accessibility
    render template: "pages/accessibility"
  end

  def show
    render template: "content/#{params[:page]}", layout: "layouts/content"
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
end
