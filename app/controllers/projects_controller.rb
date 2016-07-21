class ProjectsController < ApplicationController
  before_action :set_project, only: [:show, :edit, :update, :destroy, :update_from_github]

  def update_from_github
    @project.update_project
    redirect_to @project
  end

  # GET /projects
  # GET /projects.json
  def index
    if params[:github_name]
      @user = User.find_by_github_name(params[:github_name])
      @projects = @user.projects
    else
      @projects = Project.all
    end
  end

  # GET /projects/1
  # GET /projects/1.json
  def show
    @issues = Issue.where(project: @project)
  end

  # GET /projects/new
  def new
    @project = Project.new
    if params[:collection_id]
      @collection = Collection.find(params[:collection_id])
    else
      @collections = current_user.collections
    end
  end

  # GET /projects/1/edit
  def edit
  end

  # POST /projects
  # POST /projects.json
  def create
    @project = Project.new(project_params)
    @project.update_project

    respond_to do |format|
      if @project.save
        format.html { redirect_to @project, notice: 'Project was successfully created.' }
        format.json { render :show, status: :created, location: @project }
      else
        format.html { render :new }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
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
      format.html { redirect_to projects_url, notice: 'Project was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project
      @project = Project.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def project_params
      params.require(:project).permit(:url, :collection_id)
    end
end
