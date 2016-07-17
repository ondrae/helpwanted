Rails.application.routes.draw do
  devise_for :users, :controllers => { :omniauth_callbacks => "callbacks" }
  root 'application#index'
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
