class IssuesController < ApplicationController
  before_action :set_issue, only: [:show]

  # GET /issues
  # GET /issues.json
  def index
    if params[:project_id]
      @project = Project.find(params[:project_id])
      @issues = @project.issues.page(params[:page])
      @title = @project.name + "'s Issues"
    elsif params[:collection_id]
      @collection = Collection.friendly.find(params[:collection_id])
      @issues = @collection.issues.page(params[:page])
      @title = @collection.name + "'s Issues"
    elsif params[:user_id]
      user = User.friendly.find(params[:user_id])
      @issues = user.issues.page(params[:page])
    else
      @issues = Issue.page(params[:page])
    end
    if params[:search]
      @issues = search_with_pagination
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

    def search_with_pagination
      search_array = search_labels + search_titles
      Kaminari.paginate_array(search_array).page(params[:page]).per(50)
    end

    def search_labels
      @issues.joins(:labels).where("labels.name ILIKE :search", { search: "%#{params[:search]}%" } )
    end

    def search_titles
      @issues.basic_search(params[:search])
    end
end
