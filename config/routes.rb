Rails.application.routes.draw do
  root 'application#index'

  # admin
  match "/delayed_job" => DelayedJobWeb, :anchor => false, via: [:get, :post]

  devise_for :users, :controllers => { :omniauth_callbacks => "callbacks" }
  resources :users, path: "people" do
    member do
      put "update_from_github"
    end
  end

  resources :collections do
    get "projects" => "projects#index"
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
  #
  get ":github_name" => "users#show", as: "user_page"

  # Routes for humans
  get ":github_name/collections" => "collections#index", as: "users_collections"
  get ":github_name/projects" => "projects#index", as: "users_projects"
  get ":github_name/issues" => "issues#index", as: "users_issues"
end
