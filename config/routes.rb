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

  get ":github_name" => "users#show"
  get ":github_name/collections" => "collections#index"
  get ":github_name/projects" => "projects#index"
  get ":github_name/issues" => "issues#index"
end
