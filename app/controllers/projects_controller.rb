class ProjectsController < ApplicationController
  before_action :set_project, only: [:show, :edit, :update, :destroy, :update_from_github]
  before_action :must_be_logged_in, only: [:new, :edit, :create, :update, :destroy, :update_from_github]

  def update_from_github
    @project.update_project
    @project.update_issues
    redirect_to @project
  end

  # GET /projects
  # GET /projects.json
  def index
    if params[:collection_id]
      @collection = Collection.friendly.find(params[:collection_id])
      @projects = @collection.projects
    elsif params[:github_name]
      @user = User.find_by_github_name(params[:github_name])
      @projects = @user.projects
    else
      @projects = Project.order(github_updated_at: :desc)
    end
  end

  # GET /projects/1
  # GET /projects/1.json
  def show
  end

  # GET /projects/new
  def new
    @project = Project.new
    @collections = current_user.collections
  end

  # GET /projects/1/edit
  def edit
  end

  # POST /projects
  # POST /projects.json
  def create

    if create_single_project?
      @project = Project.create(project_params)
      @project.update_project
      @project.update_issues
      @collection = Collection.find(@project.collection_id)
      redirect_to collection_path(@collection)

    elsif create_all_orgs_projects?

      @projects = GithubOrganization.new(project_params[:url]).projects
      @projects.map do |gh_project|
        gh_project_params = {
          name: gh_project.name,
          description: gh_project.description,
          url: gh_project.html_url,
          collection_id: project_params[:collection_id]
        }
        project = Project.create(gh_project_params)
        if project.valid?
          project.update_issues
        end
      end
      @collection = Collection.find(project_params[:collection_id])
      redirect_to collection_path(@collection)
    end

  end

  # PATCH/PUT /projects/1
  # PATCH/PUT /projects/1.json
  def update
    respond_to do |format|
      if @project.update(project_params)
        format.html { redirect_to @project, notice: 'Project was successfully updated.' }
        format.json { render :show, status: :ok, location: @project }
      else
        format.html { render :edit }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
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
