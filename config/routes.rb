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
  get "/cookie-policy", to: "pages#show", page: "cookie-policy"

  resources "events", path: "/events", only: %i[index show search] do
    collection do
      get "search"
      get "category/school-and-university-event", to: "events#show_category", category: "school-or-university-event"
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

  get "/life-as-a-teacher/my-story-into-teaching", to: "pages#show", page: "life-as-a-teacher/my-story-into-teaching"
  get "/life-as-a-teacher/my-story-into-teaching/career-changers", to: "pages#show", page: "life-as-a-teacher/my-story-into-teaching/career-changers"
  get "/life-as-a-teacher/my-story-into-teaching/international-career-changers", to: "pages#show", page: "life-as-a-teacher/my-story-into-teaching/international-career-changers"
  get "/life-as-a-teacher/my-story-into-teaching/making-a-difference", to: "pages#show", page: "life-as-a-teacher/my-story-into-teaching/making-a-difference"
  get "/life-as-a-teacher/my-story-into-teaching/teacher-training-stories", to: "pages#show", page: "life-as-a-teacher/my-story-into-teaching/teacher-training-stories"
  get "/life-as-a-teacher/my-story-into-teaching/*story", to: "stories#show"

  get "/guidance", to: "pages#showblank", page: "guidance"

  get "*page", to: "pages#show", as: :page
end
