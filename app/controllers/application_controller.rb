class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :set_title

  def set_title
    if params[:controller] == "application"
      @title = "All Git Everything"
    else
      @title = params[:controller].capitalize.pluralize
    end
  end

  def index
    if params[:search]
      @collections = Collection.basic_search params[:search]
      @projects = Project.basic_search params[:search]
      @issues = Issue.basic_search params[:search]
    end
  end

end
