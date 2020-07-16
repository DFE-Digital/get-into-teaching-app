Rails.application.routes.draw do
  root to: "pages#home"

  get "/404", to: "errors#not_found", via: :all
  get "/422", to: "errors#unprocessable_entity", via: :all
  get "/500", to: "errors#internal_server_error", via: :all
  if Rails.env.rolling? || Rails.env.preprod? || Rails.env.production?
    get "/assets/*missing", to: "errors#not_found", via: :all
  end

  get "/healthcheck.json", to: "healthchecks#show", as: :healthcheck

  get "/scribble", to: "pages#scribble", via: :all, as: nil
  get "/events", to: "pages#events", via: :all, as: nil
  get "/eventschool", to: "pages#eventschool", via: :all
  get "/events_ttt", to: "pages#events_ttt", via: :all
  get "/events_online", to: "pages#events_online", via: :all
  get "/events_school", to: "pages#events_school", via: :all
  get "/event", to: "pages#event", via: :all, as: nil
  get "/event/register/:step_number", to: "pages#eventregistration", via: :all
  get "/mailinglist/register/:step_number", to: "pages#mailingregistration", via: :all

  resources "events", path: "/apievents", only: %i[index show search] do
    collection { get "search" }
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
      collection { get :completed }
    end
  end

  get "*page", to: "pages#show", as: :page
end
