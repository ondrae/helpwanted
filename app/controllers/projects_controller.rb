class ProjectsController < ApplicationController
  before_action :set_project, only: [:destroy, :update_from_github]
  before_action :set_collection, except: :destroy
  before_action :must_be_logged_in, only: [:destroy, :update_from_github]
  protect_from_forgery :except => [:create]

  def update_from_github
    @project.update_project
    @project.update_issues
    render nothing: true
  end

  # GET /projects
  # GET /projects.json
  def index
    @title = @collection.name + "'s Projects"
    @projects = @collection.projects.page(params[:page])
  end

  # GET /projects/new
  def new
    @title = "Add a Project"
    @project = Project.new
    @collection = Collection.friendly.find(params[:collection_id])
  end

  # POST /projects
  # POST /projects.json
  def create
    @project = Project.create(project_params.merge(name: repo_name))

    if create_single_project?
      if @project.errors.empty?
        @project.update_project
        @project.update_issues
        redirect_to collection_projects_path @collection
      else
        render :new
      end

    elsif create_all_orgs_projects?
      organization = Organization.create!(name: project_params[:url], collection: @collection)
      organization.get_new_projects
      redirect_to collection_projects_path @collection

    else
      render :new
    end
  end

  # DELETE /projects/1
  # DELETE /projects/1.json
  def destroy
    @project.destroy
    redirect_to :back
  end

  private
  def create_single_project?
    /github\.com\/(?<repo_path>[a-zA-Z\-_0-9]+\/[a-zA-Z\-_0-9\.]+)\/?/ =~ params[:project][:url]
    repo_path.present?
  end

  def repo_name
    /github\.com\/[a-zA-Z\-_0-9]+\/(?<name>[a-zA-Z\-_0-9\.]+)\/?/ =~ params[:project][:url]
    name
  end

  def create_all_orgs_projects?
    /github\.com\/(?<org_name>[a-zA-Z\-_0-9]+)?/ =~ params[:project][:url]
    org_name.present?
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_project
    @project = Project.find(params[:project_id] || params[:id])
  end

  def set_collection
    @collection = Collection.friendly.find(params[:collection_id])
  end

  def must_be_logged_in
    redirect_to user_github_omniauth_authorize_path unless current_user
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def project_params
    params.require(:project).permit(:url, :collection_id)
  end
end
