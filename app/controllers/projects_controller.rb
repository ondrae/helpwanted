class ProjectsController < ApplicationController
  before_action :set_collection, except: :destroy
  before_action :owner_only, only: [:destroy]
  protect_from_forgery :except => [:create]

  # GET /projects
  def index
  end

  # GET /projects/new
  def new
    @title = "Add a Project"
    @project = Project.new
    @collection = Collection.friendly.find(params[:collection_id])
  end

  # POST /projects
  def create
    @project = Project.create(project_params)
    if @project.errors.empty?
      redirect_to short_collection_path @collection
    else
      render :new
    end
  end

  # DELETE /projects/1
  def destroy
    project = Project.find(params[:id])
    project.destroy
    redirect_to short_collection_path project.collection
  end

  private

  def set_collection
    @collection = Collection.friendly.find(params[:collection_id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def project_params
    params.require(:project).permit(:url, :collection_id)
  end

  def owner_only
    @project = Project.find(params[:id])
    render json: {}, status: :forbidden unless current_user == @project.collection.user
  end
end
