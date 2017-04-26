Rails.application.routes.draw do
  root 'application#index'

  # admin
  match "/delayed_job" => DelayedJobWeb, :anchor => false, via: [:get, :post]

  devise_for :users, :controllers => { :omniauth_callbacks => "callbacks" }
  resources :users do
    get "collections", to: "collections#index"
  end

  resources :collections do
    resources :projects, shallow: true
    get "issues" => "issues#index"
    member do
      put "update_from_github"
      get "embed"
    end
  end

  get ":id", to: 'collections#show', as: "short_collection"

  put "issues/:id/feature", to: "issues#feature", as: "feature_issue"
end
