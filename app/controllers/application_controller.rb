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
    @collections = Collection.all.page(params[:page])
    if params[:search]
      @collections = Collection.basic_search params[:search]
      @projects = Project.basic_search params[:search]
      @issues = search_labels + search_titles
    end
  end

  private
    def search_labels
      Issue.all.joins(:labels).where("name ILIKE :search", { search: "%#{params[:search]}%" } )
    end

    def search_titles
      Issue.all.basic_search params[:search]
    end

end
