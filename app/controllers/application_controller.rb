class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :set_title

  def set_title
    # can be overwritten in the views
    @title = params[:controller].capitalize.pluralize
  end

  def index
    @issues = Issue.help_wanted.page(params[:page])
    @issues.each do |issue|
      issue.increment! :viewed
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
