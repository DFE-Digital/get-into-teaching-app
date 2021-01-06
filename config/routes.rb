Rails.application.routes.draw do
  root to: "pages#show", page: "home"

  get "/404", to: "errors#not_found", via: :all
  get "/422", to: "errors#unprocessable_entity", via: :all
  get "/500", to: "errors#internal_server_error", via: :all
  get "/healthcheck.json", to: "healthchecks#show", as: :healthcheck

  YAML.load_file(Rails.root.join("config/redirects.yml")).fetch("redirects").tap do |redirect_rules|
    redirect_rules.each { |from, to| get from, to: redirect(to) }
  end

  if Rails.env.rolling? || Rails.env.preprod? || Rails.env.production?
    get "/assets/*missing", to: "errors#not_found", via: :all
  end

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
      get "category/:category/archive", to: "events#show_category", as: :event_category_archive, archive: true
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
  get "/my-story-into-teaching", to: "stories#landing"
  get(
    "/my-story-into-teaching/*story/",
    to: "stories#show",
    constraints: ->(params) { params["story"] =~ /.*\/(.+)/ },
  )
  get "/my-story-into-teaching/*story/", to: "stories#index"

  get "/steps-to-become-a-teacher", to: "steps_to_become_a_teacher#show"
  get "/ways-to-train", to: "ways_to_train#show"

  get "/guidance/*page", to: "guidance#show"
  get "*page", to: "pages#show", as: :page
end
