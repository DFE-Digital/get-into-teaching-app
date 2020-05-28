Rails.application.routes.draw do
  root to: "pages#home"

  get "/404", to: "errors#not_found", via: :all
  get "/422", to: "errors#unprocessable_entity", via: :all
  get "/500", to: "errors#internal_server_error", via: :all
  get "/events", to: "pages#events", via: :all
  get "/eventschool", to: "pages#eventschool", via: :all
  get "/event", to: "pages#event", via: :all
  get "/event/register/1", to: "pages#eventregistration", via: :all
  get "/event/register/2", to: "pages#eventregistration2", via: :all
  get "/event/register/3", to: "pages#eventregistration3", via: :all
  get "/event/register/4", to: "pages#eventregistration4", via: :all
  get "/event/register/5", to: "pages#eventregistration5", via: :all

  if Rails.env.development?
    get "/apistubs/*stub", to: "apistubs#show"
  end

  get "*page", to: "pages#show", as: :page
end
