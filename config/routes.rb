Rails.application.routes.draw do
  root to: "pages#show", page: "home"

  get "/robots.txt", to: "robots#show"
  get "/events/not-available", to: "events#not_available"
  get "/mailinglist/not-available", to: "mailing_list/steps#not_available"
  get "/callbacks/not-available", to: "callbacks/steps#not_available"

  get "/404", to: "errors#not_found", via: :all
  get "/422", to: "errors#unprocessable_entity", via: :all
  get "/500", to: "errors#internal_server_error", via: :all
  get "/403", to: "errors#forbidden"
  get "/healthcheck.json", to: "healthchecks#show", as: :healthcheck
  get "/sitemap.xml", to: "sitemap#show", via: :all

  YAML.load_file(Rails.root.join("config/redirects.yml")).fetch("redirects").tap do |redirect_rules|
    redirect_rules.each do |from, to|
      get from => lambda { |env|
        Rails.logger.info(redirect: { request: env["ORIGINAL_FULLPATH"], from: from, to: to })
        redirect(path: to).call(env)
      }
    end
  end

  if Rails.env.rolling? || Rails.env.preprod? || Rails.env.production? || Rails.env.pagespeed?
    get "/assets/*missing", to: "errors#not_found", via: :all
  end

  post "/pagespeed/run", constraints: -> { Rails.env.pagespeed? }, to: proc { |_env|
    require "page_speed_score"

    sitemap_url = "https://getintoteaching.education.gov.uk/sitemap.xml"
    page_speed_score = PageSpeedScore.new(sitemap_url)
    page_speed_score.fetch

    [204, {}, []]
  }

  post "/assets/check", constraints: -> { Rails.env.pagespeed? }, to: proc { |_env|
    require "asset_checker"

    root_url = "https://getintoteaching.education.gov.uk"
    checker = AssetChecker.new(root_url)
    result = checker.run

    [result.empty? ? 204 : 404, {}, [result.join($INPUT_RECORD_SEPARATOR)]]
  }

  namespace :internal do
    resources :events, only: %i[index show new create edit]
    put "/approve", to: "events#approve"
    put "/withdraw", to: "events#withdraw"
    get "/open_events", to: "events#open_events"
  end

  get "/funding-and-support/scholarships-and-bursaries", to: "pages#scholarships_and_bursaries", as: "scholarships_and_bursaries"
  get "/privacy-policy", to: "pages#privacy_policy", as: :privacy_policy
  get "/cookies", to: "pages#cookies", as: :cookies
  get "/tta-service", to: "pages#tta_service", as: :tta_service
  get "/tta", to: "pages#tta_service", as: nil

  get "/welcome", to: "pages#welcome", as: :welcome_guide
  get "/welcome/my-journey-into-teaching", to: "pages#welcome_my_journey_into_teaching", as: :welcome_my_journey_into_teaching

  # param paths for welcome guide customisation
  get "/welcome/email/subject/:subject", to: "pages#welcome"
  get "/welcome/email/degree-status/:degree_status", to: "pages#welcome"
  get "/welcome/email/subject/:subject/degree-status/:degree_status", to: "pages#welcome"

  resource :search, only: %i[show]
  # resource :eligibility_checker,
  #          only: %i[show],
  #          controller: "eligibility_checker",
  #          path: "eligibility-checker"

  resource "cookie_preference", only: %i[show]
  get "/cookie-policy", to: redirect("/cookies")

  resource :csp_reports, only: %i[create]
  resource :client_metrics, only: %i[create]

  resources :blog, controller: "blog", only: %i[index show] do
    collection do
      resources :tag, only: %i[show], as: :blog_tag, controller: "blog/tag"
    end
  end

  resources "teaching_events", as: "events", path: "/events", controller: "teaching_events" do
    collection do
      get :about_ttt_events, path: "about-train-to-teach-events", as: "about_ttt"
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

  namespace :callbacks do
    resources :steps, path: "/book", only: %i[index show update] do
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
        get "completed/campaigns/:campaign_id", action: :completed
      end

      member do
        resources :campaigns, only: %i[show update], controller: "steps", param: :campaign_id
      end
    end
  end

  get "*page", to: "pages#show", as: :page, constraints: ->(request) { !request.path.start_with?("/rails/") }
end
