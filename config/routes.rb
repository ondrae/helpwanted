Rails.application.routes.draw do
  root 'application#index'
  devise_for :users, :controllers => { :omniauth_callbacks => "callbacks" }
  resources :users do
    member do
      put "update_from_github"
    end
  end
  resources :collections do
    get "issues"
    member do
      put "update_from_github"
    end
  end
  resources :projects do
    member do
      put "update_from_github"
    end
  end
  resources :issues, only: %i[index show]
end
