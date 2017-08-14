class CollectionsController < ApplicationController
  before_action :set_collection, except: [:index, :new, :create]
  before_action :owner_only, only: [:edit, :update, :destroy]
  before_action :must_be_logged_in, only: [:new, :create]

  # GET /collections
  def index
    if params[:user_id]
      user = User.friendly.find(params[:user_id])
      @collections = user.collections
    else
      @collections = Collection.all
    end
  end

  # GET /collections/1
  def show
    get_help_wanted_issues(orgs: @collection.organizations, repos: @collection.projects)
  end

  def add_issues
  end

  def embed
    response.headers.delete "X-Frame-Options"
    get_help_wanted_issues(orgs: @collection.organizations, repos: @collection.projects)
    render layout: "embed"
  end

  # GET /collections/new
  def new
    @collection = Collection.new
    @project = Project.new
    @organization = Organization.new
  end

  # GET /collections/1/edit
  def edit
    @project = Project.new
    @organization = Organization.new
  end

  # POST /collections
  def create
    @collection = Collection.new(collection_params.merge(user: current_user))
    if @collection.save
      redirect_to @collection
    else
      render :new
    end
  end

  # PATCH/PUT /collections/1
  def update
    if @collection.update(collection_params)
      redirect_to @collection
    else
      render :edit
    end
  end

  # DELETE /collections/1
  def destroy
    @collection.destroy
    redirect_to collections_url
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_collection
      @collection = Collection.friendly.find params[:id]
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def collection_params
      params.require(:collection).permit(:name, :description, :slug)
    end

    def owner_only
      render json: {}, status: :forbidden unless current_user == @collection.user
    end
end
