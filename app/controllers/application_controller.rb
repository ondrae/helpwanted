class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def index
    @collection_count = Collection.all.count
    @project_count = Project.all.count
    @issue_count = Issue.all.count
    @user_count = User.all.count
  end



end
