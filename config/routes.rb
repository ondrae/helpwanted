Rails.application.routes.draw do
  root 'application#index'

  devise_for :users, :controllers => { :omniauth_callbacks => "callbacks" }
  resources :users do
    get "collections", to: "collections#index"
    get "/rate_limit", to: "application#rate_limit", as: "rate_limit"
  end

  resources :collections do
    resources :organizations, shallow: true
    resources :projects, shallow: true
    get "issues" => "issues#index"
    member do
      get "add_issues"
      get "embed"
    end
  end

  get ":id", to: 'collections#show', as: "short_collection"
end
