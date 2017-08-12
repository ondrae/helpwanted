class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :set_title

  def set_title
    # can be overwritten in the views
    @title = params[:controller].capitalize.pluralize
  end

  def index
    get_help_wanted_issues(orgs: Organization.all, repos: Project.all)
  end

  def get_help_wanted_issues(orgs: orgs, repos: repos)
    return if orgs.blank? or repos.blank?

    orgs_for_search = orgs.map { |org| "org:" + org.name }
    repos_for_search = repos.map { |repo| "repo:" + repo.owner_login + "/" + repo.name }
    query = "type:issue state:open label:\"help wanted\"" + orgs_for_search.join(" ") + " " + repos_for_search.join(" ")
    @github_api = Octokit::Client.new(access_token: ENV["GITHUB_TOKEN"], auto_paginate: false)
    result = @github_api.search_issues(query, { sort: "updated" })
    @issues = result.items.map do |github_issue|
      Issue.new(github_issue)
    end
  end

  def rate_limit
    github_api = Octokit::Client.new(access_token: ENV["GITHUB_TOKEN"])
    render inline: github_api.rate_limit.to_json
  end

  private

    def after_sign_in_path_for(resource)
      session[:previous_url] || root_path
    end

    def after_sign_out_path_for(resource)
      request.referrer
    end

    def must_be_logged_in
      redirect_to user_github_omniauth_authorize_path unless current_user
    end
end
