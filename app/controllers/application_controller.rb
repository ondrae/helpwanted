class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def index
    @collection_count = Collection.count
    @project_count = Project.count
    @issue_count = Issue.count
    @user_count = User.count
  end

end
