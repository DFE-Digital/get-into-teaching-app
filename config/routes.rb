Rails.application.routes.draw do
  root to: "pages#show", page: "home"

  get "/404", to: "errors#not_found", via: :all
  get "/422", to: "errors#unprocessable_entity", via: :all
  get "/500", to: "errors#internal_server_error", via: :all

  if Rails.env.rolling? || Rails.env.preprod? || Rails.env.production?
    get "/assets/*missing", to: "errors#not_found", via: :all
  end

  get "/healthcheck.json", to: "healthchecks#show", as: :healthcheck
  get "/privacy-policy", to: "pages#privacy_policy", as: :privacy_policy
  get "/cookies", to: "pages#cookies", as: :cookies
  get "/tta-service", to: "pages#tta_service", as: :tta_service
  get "/tta", to: "pages#tta_service", as: nil

  resource "cookie_preference", only: %i[show]
  get "/cookie-policy", to: redirect("/cookies")

  resource :csp_reports, only: %i[create]

  resources "events", path: "/events", only: %i[index show search] do
    collection do
      get "search"
      get "category/:category", to: "events#show_category", as: :event_category
    end
    resources "steps",
              path: "/apply",
              controller: "event_steps",
              only: %i[index show update] do
      collection do
        get :completed
        get :resend_verification
      end
    end
  end

  namespace :mailing_list, path: "/mailinglist" do
    resources :steps,
              path: "/signup",
              only: %i[index show update] do
      collection do
        get :completed
        get :resend_verification
      end
    end
  end

  # if the story path contains a slash followed by any text, it's a story
  # if it has no slashes or ends in a slash, it's an index page
  get "/life-as-a-teacher/my-story-into-teaching", to: "stories#landing"
  get(
    "/life-as-a-teacher/my-story-into-teaching/*story/",
    to: "stories#show",
    constraints: ->(params) { params["story"] =~ /.*\/(.+)/ },
  )
  get "/life-as-a-teacher/my-story-into-teaching/*story/", to: "stories#index"

  get "/guidance", to: "pages#showblank", page: "guidance"
  get "/financial-support-for-teacher-training", to: "pages#showblank", page: "financial-support-for-teacher-training"
  get "/train-to-become-a-teacher", to: "pages#showblank", page: "train-to-become-a-teacher"
  get "/returning-to-teaching-guidance", to: "pages#showblank", page: "returning-to-teaching-guidance"

  get "*page", to: "pages#show", as: :page
end
