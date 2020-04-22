Rails.application.routes.draw do
  root to: 'pages#home'
  get "/pages/:page", to: "pages#show"

  get "/design_system", to: "design_system#index"
  get "/design_system/components/:id", to: "design_system#components_show", as: :component
  get "/design_system/components", to: "design_system#components_index", as: :components

  get "/404", to: "errors#not_found", via: :all
  get "/422", to: "errors#unprocessable_entity", via: :all
  get "/500", to: "errors#internal_server_error", via: :all
end
