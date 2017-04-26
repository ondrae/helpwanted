class IssuesController < ApplicationController
  before_action :owner_only

  def feature
    @issue = Issue.find(params[:id])
    @issue.update featured: true
    redirect_to :back
  end

  private
  def owner_only
    @issue = Issue.find(params[:id])
    render json: {}, status: :forbidden unless current_user == @issue.project.collection.user
  end
end
