class IssuesController < ApplicationController
  before_action :set_issue, only: [:show]

  # GET /issues
  # GET /issues.json
  def index
    if params[:project_id]
      @project = Project.friendly.find(params[:project_id])
      @issues = @project.issues
      @headline = @project.name + "'s Issues"
    elsif params[:collection_id]
      @collection = Collection.friendly.find(params[:collection_id])
      @issues = @collection.issues
      @headline = @collection.name + " Issues"
    elsif params[:github_name]
      @user = User.find_by_github_name(params[:github_name])
      @issues = @user.issues
      @headline = @user.github_name.capitalize + "'s Issues"
    else
      @issues = Issue.all
      @headline = "All Issues"
    end
  end

  # GET /issues/1
  # GET /issues/1.json
  def show
  end

  # DELETE /issues/1
  # DELETE /issues/1.json
  def destroy
    @issue.destroy
    respond_to do |format|
      format.html { redirect_to issues_url, notice: 'Issue was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_issue
      @issue = Issue.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def issue_params
      params.require(:issue).permit(:title, :url, :labels, :project_id)
    end
end
