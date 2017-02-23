class ProjectsController < ApplicationController
  before_action :set_project, only: [:destroy, :update_from_github]
  before_action :must_be_logged_in, only: [:destroy, :update_from_github]

  def update_from_github
    @project.update_project
    @project.update_issues
    redirect_to request.referer
  end

  # GET /projects
  # GET /projects.json
  def index
    if params[:collection_id]
      collection = Collection.friendly.find(params[:collection_id])
      @projects = collection.projects.page(params[:page])
      @title = collection.name + "'s Projects"
    elsif params[:user_id]
      user = User.friendly.find(params[:user_id])
      @projects = user.projects.page(params[:page])
    else
      @projects = Project.all.page(params[:page])
    end
    if params[:search]
      @projects = @projects.basic_search(params[:search]).page(params[:page])
    end
  end

  # GET /projects/new
  def new
    @project = Project.new
    @collections = current_user.collections
    if params[:collection_id]
      @current_collection = Collection.friendly.find(params[:collection_id])
    else
      @current_collection = nil
    end
  end

  # POST /projects
  # POST /projects.json
  def create

    if create_single_project?
      @project = Project.new(project_params)
      @project.update_project
      @project.update_issues
      @collection = Collection.friendly.find(project_params[:collection_id])
      redirect_to collection_projects_path(@collection)

    elsif create_all_orgs_projects?
      @collection = Collection.friendly.find(project_params[:collection_id])
      organization = Organization.create!(name: project_params[:url], collection: @collection)
      organization.update_projects
      redirect_to collection_projects_path(@collection)

    else
      redirect_to new_project_path
    end

  end

  # DELETE /projects/1
  # DELETE /projects/1.json
  def destroy
    @project.destroy
    respond_to do |format|
      format.html { redirect_to :back, notice: 'Project was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  def create_single_project?
    /github\.com\/(?<repo_path>[a-zA-Z\-_0-9]+\/[a-zA-Z\-_0-9\.]+)\/?/ =~ params[:project][:url]
    repo_path.present?
  end

  def create_all_orgs_projects?
    /github\.com\/(?<org_name>[a-zA-Z\-_0-9]+)?/ =~ params[:project][:url]
    org_name.present?
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_project
    @project = Project.find(params[:project_id] || params[:id])
  end

  def must_be_logged_in
    redirect_to user_github_omniauth_authorize_path unless current_user
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def project_params
    params.require(:project).permit(:url, :collection_id)
  end
end
