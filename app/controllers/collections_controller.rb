class CollectionsController < ApplicationController
  before_action :set_collection, except: [:index, :new, :create]
  before_action :owner_only, only: [:edit, :update, :destroy]
  before_action :must_be_logged_in, only: [:new, :create]

  # GET /collections
  # GET /collections.json
  def index
    if params[:user_id]
      user = User.friendly.find(params[:user_id])
      @collections = user.collections.page(params[:page])
    else
      @collections = Collection.all.page(params[:page])
    end
  end

  # GET /collections/1
  # GET /collections/1.json
  def show
    @issues = @collection.issues.help_wanted.page(params[:page])
    @issues.each do |issue|
      issue.increment! :viewed
    end
  end

  def embed
    response.headers.delete "X-Frame-Options"
    @issues = @collection.issues.help_wanted.page(params[:page])
    @issues.each do |issue|
      issue.increment! :viewed
    end
    render layout: "embed"
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
