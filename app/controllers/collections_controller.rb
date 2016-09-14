class CollectionsController < ApplicationController
  before_action :set_collection, only: [:show, :edit, :update, :destroy, :issues, :update_from_github]

  def update_from_github
    @collection.update_projects
    redirect_to @collection
  end

  # GET /collections
  # GET /collections.json
  def index
    if params[:github_name]
      @user = User.find_by_github_name(params[:github_name])
      @collections = @user.collections
    else
      @collections = Collection.all
    end
  end

  # GET /collections/1
  # GET /collections/1.json
  def show
    @projects = @collection.projects
  end

  # GET /collections/new
  def new
    @collection = Collection.new
  end

  # GET /collections/1/edit
  def edit
  end

  # POST /collections
  # POST /collections.json
  def create
    @collection = Collection.new(collection_params.merge(user: current_user))

    respond_to do |format|
      if @collection.save
        format.html { redirect_to @collection, notice: 'Collection was successfully created.' }
        format.json { render :show, status: :created, location: @collection }
      else
        format.html { render :new }
        format.json { render json: @collection.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /collections/1
  # PATCH/PUT /collections/1.json
  def update
    respond_to do |format|
      if @collection.update(collection_params)
        format.html { redirect_to @collection, notice: 'Collection was successfully updated.' }
        format.json { render :show, status: :ok, location: @collection }
      else
        format.html { render :edit }
        format.json { render json: @collection.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /collections/1
  # DELETE /collections/1.json
  def destroy
    @collection.destroy
    respond_to do |format|
      format.html { redirect_to collections_url, notice: 'Collection was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def issues
    @issues = @collection.issues
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_collection
      if params[:id]
        @collection = Collection.find_by name: params[:id]
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def collection_params
      params.require(:collection).permit(:name, :description)
    end
end
