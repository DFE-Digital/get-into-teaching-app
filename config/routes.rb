Rails.application.routes.draw do
  if Rails.configuration.x.enable_beta_redirects
    constraints(host: "beta-getintoteaching.education.gov.uk") do
      get "/(*path)", to: redirect(host: "getintoteaching.education.gov.uk")
    end
  end

  root to: "pages#show", page: "home"

  get "/robots.txt", to: "robots#show"
  get "/events/not-available", to: "events#not_available"
  get "/mailinglist/not-available", to: "mailing_list/steps#not_available"

  get "/404", to: "errors#not_found", via: :all
  get "/422", to: "errors#unprocessable_entity", via: :all
  get "/500", to: "errors#internal_server_error", via: :all
  get "/healthcheck.json", to: "healthchecks#show", as: :healthcheck
  get "/sitemap.xml", to: "sitemap#show", via: :all

  YAML.load_file(Rails.root.join("config/redirects.yml")).fetch("redirects").tap do |redirect_rules|
    redirect_rules.each { |from, to| get from, to: redirect(path: to) }
  end

  if Rails.env.rolling? || Rails.env.preprod? || Rails.env.production? || Rails.env.pagespeed?
    get "/assets/*missing", to: "errors#not_found", via: :all
  end

  post "/pagespeed/run", constraints: -> { Rails.env.pagespeed? }, to: proc { |_env|
    require "page_speed_score"

    sitemap_url = "https://getintoteaching.education.gov.uk/sitemap.xml"
    page_speed_score = PageSpeedScore.new(sitemap_url)
    page_speed_score.fetch

    PageSpeedScore.publish

    [204, {}, []]
  }

  namespace :internal do
    resources :events, only: %i[index]
  end

  get "/privacy-policy", to: "pages#privacy_policy", as: :privacy_policy
  get "/cookies", to: "pages#cookies", as: :cookies
  get "/tta-service", to: "pages#tta_service", as: :tta_service
  get "/tta", to: "pages#tta_service", as: nil

  resource :search, only: %i[show]
  resource :eligibility_checker,
           only: %i[show],
           controller: "eligibility_checker",
           path: "eligibility-checker"

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

  # Needs to have higher priority to redirect the category
  get "event-categories/online-events", to: redirect("/event-categories/online-q-as")
  get "event-categories/online-events/archive", to: redirect("/event-categories/online-q-as/archive")

  resources :event_categories, only: %i[show], path: "event-categories" do
    member do
      get "archive", to: "event_categories#show_archive"
    end
  end
  # The event category pages used to exist here - once we're sure no traffic is
  # coming to these paths we can safely remove these redirects.
  get "events/category/:id/", to: redirect("/event-categories/%{id}")
  get "events/category/:id/archive", to: redirect("/event-categories/%{id}/archive")
  get "event_categories/:id", to: redirect("/event-categories/%{id}")
  get "event_categories/:id/archive", to: redirect("/event-categories/%{id}/archive")

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
