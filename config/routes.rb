Rails.application.routes.draw do
  root to: 'pages#home'

  get "/404", to: "errors#not_found", via: :all
  get "/422", to: "errors#unprocessable_entity", via: :all
  get "/500", to: "errors#internal_server_error", via: :all

  get "/events", to: "pages#events", via: :all

  #get "*page", to: "pages#content", as: :page
  get "*page", to: "pages#show", as: :page
end
