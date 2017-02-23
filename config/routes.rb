Rails.application.routes.draw do
  root 'application#index'

  # admin
  match "/delayed_job" => DelayedJobWeb, :anchor => false, via: [:get, :post]

  devise_for :users, :controllers => { :omniauth_callbacks => "callbacks" }
  resources :users do
    member do
      put "update_from_github"
    end
    resources :collections
    resources :projects, except: :show
    resources :issues, only: :index
  end

  resources :collections do
    resources :projects, except: :show
    get "issues" => "issues#index"
    member do
      put "update_from_github"
    end
  end

  resources :projects, except: :show do
    get "issues" => "issues#index"
    member do
      put "update_from_github"
    end
  end

  resources :issues, only: :index
end
