class ProjectsController < ApplicationController
  before_action :set_collection, except: :destroy
  before_action :must_be_logged_in, only: [:destroy]
  protect_from_forgery :except => [:create]

  # GET /projects
  # GET /projects.json
  def index
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
        redirect_to short_collection_path @collection
      else
        render :new
      end

    elsif create_all_orgs_projects?
      organization = Organization.create(project_params)
      organization.get_new_projects
      redirect_to short_collection_path @collection

    else
      render :new
    end
  end

  # DELETE /projects/1
  # DELETE /projects/1.json
  def destroy
    project = Project.find(params[:id])
    project.destroy
    redirect_to short_collection_path project.collection
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
