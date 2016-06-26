Rails.application.routes.draw do
  root 'application#index'
  resources :collections
  resources :projects do
    member do
      put "update_from_github"
    end
  end
  resources :issues, only: %i[index show]
end
