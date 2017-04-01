class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :set_title
  after_filter :store_location

  def set_title
    # can be overwritten in the views
    @title = params[:controller].capitalize.pluralize
  end

  def index
    @issues = Issue.help_wanted.page(params[:page]).per(9)
  end

  private
    # def search_labels
    #   Issue.all.joins(:labels).where("name ILIKE :search", { search: "%#{params[:search]}%" } )
    # end
    #
    # def search_titles
    #   Issue.all.basic_search params[:search]
    # end

    def store_location
      # store last url - this is needed for post-login redirect to whatever the user last visited.
      return unless request.get?
      if (request.path != "/users/sign_in" &&
          request.path != "/users/sign_out" &&
          !request.xhr?) # don't store ajax calls
        session[:previous_url] = request.fullpath
      end
    end

    def after_sign_in_path_for(resource)
      session[:previous_url] || root_path
    end

    def after_sign_out_path_for(resource)
      request.referrer
    end
end
