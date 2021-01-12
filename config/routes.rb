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

  resource :search, only: %i[show]

  resource "cookie_preference", only: %i[show]
  get "/cookie-policy", to: redirect("/cookies")

  resource :csp_reports, only: %i[create]

  resources "events", path: "/events", only: %i[index show search] do
    collection do
      get "search"
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

  resources :event_categories, only: %i[show] do
    member do
      get "archive", to: "event_categories#show_archive"
    end
  end
  # The event category pages used to exist here - once we're sure no traffic is
  # coming to these paths we can safely remove these redirects.
  get "events/category/:id/", to: redirect("/event_categories/%{id}/")
  get "events/category/:id/archive", to: redirect("/event_categories/%{id}/archive")

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

  get "/guidance/*page", to: "guidance#show"
  get "*page", to: "pages#show", as: :page, constraints: ->(request) { !request.path.start_with?("/rails/") }
end
