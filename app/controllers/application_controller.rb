class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def index
    get_help_wanted_issues(orgs: Organization.all, repos: Project.all)
  end

  def get_help_wanted_issues(orgs:, repos:, featured: nil)
    return if orgs.blank? and repos.blank?

    @github_api = Octokit::Client.new(access_token: ENV["GITHUB_TOKEN"], auto_paginate: false)
    orgs_for_search = orgs.map { |org| "org:" + org.name }.uniq
    repos_for_search = repos.map { |repo| "repo:" + repo.full_name }.uniq
    help_wanted_query = "type:issue state:open label:\"help wanted\"" + orgs_for_search.join(" ") + " " + repos_for_search.join(" ")
    help_wanted_result = @github_api.search_issues(help_wanted_query, { sort: "updated", per_page: 100 })
    @issues = help_wanted_result.items.map { |github_issue| Issue.new github_issue }

    if featured.present?
      featured_query = "type:issue state:open label:\"help wanted\" label:\"#{featured}\"" + orgs_for_search.join(" ") + " " + repos_for_search.join(" ")
      featured_result = @github_api.search_issues(featured_query, { sort: "updated", per_page: 100 })
      featured_issues = featured_result.items.map { |github_issue| Issue.new github_issue }
      @issues = featured_issues + @issues
      @issues = @issues.uniq { |issue| issue.url }
    end
  end

  def rate_limit
    github_api = Octokit::Client.new(access_token: ENV["GITHUB_TOKEN"])
    render inline: github_api.rate_limit.to_json
  end

  private

  def must_be_logged_in
    redirect_to user_github_omniauth_authorize_path unless current_user
  end
end
